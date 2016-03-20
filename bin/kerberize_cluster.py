#!/usr/bin/python
import sys, httplib, urllib, base64, string, json, time
from datetime import datetime

debug=True
def log_debug(msg):
  if debug:
    print msg
    
def print_usage():
  print "Usage"
  print "kerberize_cluster.py %ambari_admin %ambari_admin_password %ambari_host %ambari_port %clustername %kdc_host %REALM %principal %principal_password"
  print "\nExample:"
  print "kerberize_cluster.py admin admin localhost 8080 Sandbox one.hdp MYCORP.NET hdp/admin@MYCORP.NET hadoop"

log_debug('args length: %d' % len(sys.argv))
if len(sys.argv) == 10:
  script, amb_username, amb_password, amb_host, amb_port, clustername,  kdc_host, realm, principal, princ_password = sys.argv
elif len(sys.argv) == 9:
  amb_username, amb_password, amb_host, amb_port, clustername,  kdc_host, realm, principal, princ_password = sys.argv
else:
  print_usage()
  sys.exit()

log_debug('amb_username: %s' % amb_username)
log_debug('amb_password: %s' % amb_password)
log_debug('amb_host: %s' % amb_host)
log_debug('amb_port: %s' % amb_port)
log_debug('clustername: %s' % clustername)
log_debug('realm: %s' % realm)
log_debug('principal: %s' % principal)
log_debug('princ_password: %s' % princ_password)

auth = base64.encodestring('%s:%s' % (amb_username, amb_password)).replace('\n','')
log_debug('auth: %s' % auth)



def execute_request(method, path, msg=''):
  log_debug('execute_request.method: %s' % method)
  log_debug('execute_request.path: %s' % path)
  log_debug('execute_request.msg: %s' % msg)
  webservice = httplib.HTTPConnection(amb_host, amb_port)
  webservice.putrequest(method, path)
  webservice.putheader('X-Requested-by', 'ambari')
  webservice.putheader("Authorization", "Basic %s" % auth)
  webservice.putheader("Content-length", "%d" % len(msg))
  webservice.endheaders()
  webservice.send(msg)
  res = webservice.getresponse()
  data = res.read()
  print "Response: ", res.status, res.reason
  print data
  return res, data

  
def execute_and_wait_completed(method, path, msg=''):
  req_res, req_res_data = execute_request(method, path, msg)
  log_debug("execute_and_wait_completed.req_res.status: %s, %s" % (req_res.status, req_res.reason))
  log_debug("execute_and_wait_completed.req_res_data: %s" % req_res_data)
  if len(req_res_data) == 0:
    return
  req_id = json.loads(req_res_data)["Requests"]["id"]
  
  limit=36
  
  for i in range(0, limit):
    log_debug('execute_and_wait_completed.id: %d' % req_id)
    status_req, status_req_data =  execute_request('GET', '/api/v1/clusters/%s/requests/%d' % (clustername, req_id) )
    log_debug("execute_and_wait_completed.status_req.status: %s, %s" % (status_req.status, status_req.reason))
    log_debug("execute_and_wait_completed.status_req_data: %s" % status_req_data)
    status = json.loads(status_req_data)["Requests"]["request_status"] 
    if "COMPLETED" == status:
      break
    log_debug('... waiting for request to complete.')
    time.sleep(10)
    
def return_hosts():
  hosts_req, hosts_req_data = execute_request('GET', '/api/v1/clusters/%s/hosts' % clustername)
  host_items = json.loads(hosts_req_data)["items"]
  for host in host_items:
    log_debug('return_hosts.items.hosts.host_name: %s' % host["Hosts"]["host_name"])
  return host_items

print "Adding KERBEROS Service & Component"
execute_request('POST', '/api/v1/clusters/%s/services/KERBEROS' % clustername)
execute_request('POST', '/api/v1/clusters/%s/services/KERBEROS/components/KERBEROS_CLIENT' % clustername)

print "Crete krb5-env"
msg = '''[ {"Clusters": {
    "desired_configs": {
      "type": "kerberos-env",
      "tag": "version2",
      "properties": {
        "type": "kerberos-env",
        "tag": "version1",
        "properties": {
          "kdc_type": "mit-kdc",
          "encryption_types": "aes des3-cbc-sha1 rc4 des-cbc-md5",
          "realm": "%s",
          "kdc_host": "%s",
          "admin_server_host": "%s",
          "executable_search_paths": "/usr/bin, /usr/kerberos/bin, /usr/sbin, /usr/lib/mit/bin, /usr/lib/mit/sbin"
        }
      }
    }
  }
}]''' % (realm, kdc_host, kdc_host)
log_debug('krb5-env msg: %s' % msg.replace('\n', ''))
execute_request('PUT', '/api/v1/clusters/%s' % clustername, msg)

print "Create krb5-conf"
msg = '''[ { "Clusters": 
    { "desired_config": { 
        "type": "krb5-conf",
        "tag": "version1",
        "properties": {
            "conf_dir" : "/etc",
            "content" : "\\n[libdefaults]\\n
renew_lifetime = 7d\\n
forwardable = true\\n
default_realm = {{realm}}\\n
ticket_lifetime = 24h\\n
dns_lookup_realm = false\\n
dns_lookup_kdc = false\\n
#default_tgs_enctypes = {{encryption_types}}\\n
#default_tkt_enctypes = {{encryption_types}}\\n
\\n
{% if domains %}\\n
[domain_realm]\\n
{% for domain in domains.split(',') %}\\n
  {{domain}} = {{realm}}\\n
{% endfor %}\\n
{% endif %}\\n
\\n
[logging]\\n
default = FILE:/var/log/krb5kdc.log\\n
admin_server = FILE:/var/log/kadmind.log\\n
kdc = FILE:/var/log/krb5kdc.log\\n
\\n         
[realms]\\n
{{realm}} = {\\n
  admin_server = {{admin_server_host|default(kdc_host, True)}}\\n
  kdc = {{kdc_host}}\\n
}\\n
{# Append additional realm declarations below #}",
            "domains" : "",
            "manage_krb5_conf" : "false"
        }
} } } ]'''
log_debug('krb5-conf msg: %s' % msg.replace('\n', ''))
execute_request('PUT', '/api/v1/clusters/%s' % clustername, msg )

''''
msg = '''{"host_components" : [{"HostRoles" : {"component_name":"KERBEROS_CLIENT"}}]}'''
for host in return_hosts():
  execute_request('POST', '/api/v1/clusters/%s/hosts?Hosts/host_name=%s' % (clustername, host["Hosts"]["host_name"]), msg )

print "Install components"
msg = '{"ServiceInfo": {"state" : "INSTALLED"}}'
execute_and_wait_completed('PUT', '/api/v1/clusters/%s/services/KERBEROS' % clustername, msg)

msg = '{"ServiceInfo": {"state" : "INSTALLED"}}'
execute_and_wait_completed('PUT', '/api/v1/clusters/%s/services' % clustername, msg)


print "Enable Kerberos"
msg = ''''''{
  "session_attributes" : {
    "kerberos_admin" : {
      "principal" : "%s", "password" : "%s" }
    },
    "Clusters": {
      "security_type" : "KERBEROS"
  }
}'''''' % (principal, princ_password)
execute_and_wait_completed('PUT', '/api/v1/clusters/%s' % clustername, msg)

print "Restart Cluster"
msg = '{"ServiceInfo": {"state" : "STARTED"}}'
execute_and_wait_completed('PUT', '/api/v1/clusters/%s/services' % clustername, msg)
'''