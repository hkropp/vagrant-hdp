# VM-Configuration of an ambari agent that is monitored by the ambari server.

# Turn off interfering services
include interfering_services
# Install and enable ntp
include ntp

$hdp_repo='http://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP-LABS/Projects/Champlain-Preview/ambari/1.7.0-5/centos6/ambari.repo'

# Ensure that servers can find themselves even in absence of dns
class { 'etchosts':
  ownhostname => 'one.node'
}


class { 'ambari_agent':
  serverhostname => "one.node",
  ownhostname    => "two.node",
  repo => $hdp_repo
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_agent']

