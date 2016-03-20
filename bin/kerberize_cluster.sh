#!/usr/bin/env bash

#
# inspired by: https://github.com/seanorama/ambari-bootstrap/blob/master/extras/kerberos/kerberos-hdp-ad-with-ambari.sh
#
# sample execution:
#  ./kerberize_cluster.sh n1-hdp-basic localhost MYCORP.NET one.hdp one.hdp one.hdp hdp/admin@MYCORP.NET hadoop
#

set -euo pipefail

CLUSTER_NAME=$1;
AMBARI_SERVER=$2;
REALM=$3;
KDC=$4;
DOMAINS=$5;

IFS=$'\n\t'
HOSTS=($6);

PRINCIPAL=$7;
PASS=$8;

function execute_and_wait_completed() {
  local request="$1"
  local response=$(echo "${body}" | $request)
  local request_id=$(echo ${response} | python -c 'import sys,json; print json.load(sys.stdin)["Requests"]["id"]')
  
  local limit=36
  
  for(( i=0; i<${limit}; i++)); do
    local req_status=$(curl -H "X-Requested-By:ambari" -u admin:admin -X POST http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/requests/$request_id | grep request_status | uniq | tr -cd '[:upper:]')
    if [ "COMPLETED" = "$req_status" ]; then
      break
    fi
    echo "$req_status"
    sleep 10
  done
}

echo "Add KERBEROS Service + Component"
curl -H "X-Requested-By:ambari" -u admin:admin -X POST http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/KERBEROS
curl -H "X-Requested-By:ambari" -u admin:admin -X POST http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/KERBEROS/components/KERBEROS_CLIENT

echo "kerberos-env Management"
read -r -d '' body <<END
hi
afdaf
af      adv
END
#[ {"Clusters": {
#    "desired_configs": {
#      "type": "kerberos-env",
#      "tag": "version2",
#      "properties": {
#        "type": "kerberos-env",
#        "tag": "version1",
#        "properties": {
#          "kdc_type": "mit-kdc",
#          "encryption_types": "aes des3-cbc-sha1 rc4 des-cbc-md5",
#          "realm": "${REALM}",
#          "kdc_host": "${KDC}",
#          "admin_server_host": "${KDC}",
#          "executable_search_paths": "/usr/bin, /usr/kerberos/bin, /usr/sbin, /usr/lib/mit/bin, /usr/lib/mit/sbin"
#        }
#      }
#    }
#  }
#}]
#END
echo "${body}"
echo "${body}" | curl -H "X-Requested-By: ambari" -X PUT -u admin:admin "http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME" -d @-

echo "krb5.conf Management"
read -r -d '' body <<EOF
[ { "Clusters": 
    { "desired_config": { 
        "type": "krb5-conf",
        "tag": "version1",
        "properties": {
            "conf_dir" : "/etc",
            "content" : "\n[libdefaults]\n  renew_lifetime = 7d\n  forwardable = true\n  default_realm = {{realm}}\n  ticket_lifetime = 24h\n  dns_lookup_realm = false\n  dns_lookup_kdc = false\n  #default_tgs_enctypes = {{encryption_types}}\n  #default_tkt_enctypes = {{encryption_types}}\n\n{% if domains %}\n[domain_realm]\n{% for domain in domains.split(',') %}\n  {{domain}} = {{realm}}\n{% endfor %}\n{% endif %}\n\n[logging]\n  default = FILE:/var/log/krb5kdc.log\n  admin_server = FILE:/var/log/kadmind.log\n  kdc = FILE:/var/log/krb5kdc.log\n\n[realms]\n  {{realm}} = {\n    admin_server = {{admin_server_host|default(kdc_host, True)}}\n    kdc = {{kdc_host}}\n  }\n\n{# Append additional realm declarations below #}",
            "domains" : "${DOMAINS}",
            "manage_krb5_conf" : "false"
        }
} } } ]
EOF
curl -H "X-Requested-By: ambari" -X PUT -u admin:admin "http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME" -d @-

# Create host components (once for each host)  HTTP/1.1 201 Created
for i in "${HOSTS[@]}"; do
  curl -H "X-Requested-By:ambari" -u admin:admin -X POST -d '{"host_components" : [{"HostRoles" : {"component_name":"KERBEROS_CLIENT"}}]}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/hosts?Hosts/host_name=$i
done

# Installing KERBEROS service
read -r -d '' body <<EOF
{"ServiceInfo": {"state" : "INSTALLED"}}
EOF
execute_and_wait_completed 'curl -H "X-Requested-By: ambari" -X PUT -u admin:admin "http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/KERBEROS" -d @-'

# Stopping cluster
read -r -d '' body <<EOF
{"ServiceInfo": {"state" : "INSTALLED"}}
EOF
execute_and_wait_completed 'curl -H "X-Requested-By: ambari" -X PUT -u admin:admin "http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services" -d @-'

# Enable Kerberos
read -r -d '' body <<EOF
{
  "session_attributes" : {
    "kerberos_admin" : {
      "principal" : "${PRINCIPAL}", "password" : "${PASS}" }
    },
    "Clusters": {
      "security_type" : "KERBEROS"
  }
}
EOF
execute_and_wait_completed 'curl -H "X-Requested-By: ambari" -X PUT -u admin:admin "http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME" -d @-'

# Start cluster
read -r -d '' body <<EOF
{"ServiceInfo": {"state" : "STARTED"}}
EOF
execute_and_wait_completed 'curl -H "X-Requested-By: ambari" -X PUT -u admin:admin "http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services" -d @-'
