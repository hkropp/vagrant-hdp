# VM-Configuration of the ambari server. It functions as the name node and resource manager.

# Turn off interfering services
include interfering_services
# Install and enable ntp
include ntp

$hdp_repo ='http://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP-LABS/Projects/Champlain-Preview/ambari/1.7.0-5/centos6/ambari.repo'
            	
# Ensure that servers can find themselves even in absence of dns
class { 'etchosts':
  ownhostname => 'one.node'
}

# Install and enable ambari server
class { 'ambari_server':
  repo => $hdp_repo
}

# Install and enable ambari agent
class { 'ambari_agent':
  ownhostname    => 'one.node',
  serverhostname => 'one.node',
  repo => $hdp_rep
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_server'] -> Class['ambari_agent']
