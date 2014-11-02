# VM-Configuration of the ambari server. It functions as the name node and resource manager.

# Turn off interfering services
include interfering_services

# Install and enable ntp
include ntp

# Install and enable ambari server
class { 'ambari_server':
  repo => $hdp_ambari_repo
}

# Install and enable ambari agent
class { 'ambari_agent':
  ownhostname    => $ownhostname,
  serverhostname => $ambarihostname,
  repo => $hdp_ambari_repo
}

#class ambari_repolist {
#    augeas { 'repolist.xml':
#        lens => "Xml.lns",
#        incl => '/var/lib/ambari-server/resources/stacks/HDP/2.2/repos/repoinfo.xml',
#        changes => [
#            "set reposinfo/os[#attribute/type='redhat6']/repo[repoid/#text='HDP-2.2']/baseurl/#text http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Champlain-Preview/2.2.0.0-706/centos6",
#            "set reposinfo/os[#attribute/type='redhat6']/repo[repoid/#text='HDP-UTILS-1.1.0.20']/baseurl/#text http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.19/repos/centos6"
#
#       ]
#    }
#}
#include ambari_repolist

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['ambari_server'] -> Class['ambari_agent']
#-> Class['ambari_repolist']
