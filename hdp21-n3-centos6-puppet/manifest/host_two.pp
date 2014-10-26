# VM-Configuration of an ambari agent that is monitored by the ambari server.

# Turn off interfering services
include interfering_services

# Install and enable ntp
include ntp

# Ensure that servers can find themselves even in absence of dns
class { 'etchosts':
  ownhostname => 'two.node'
}


class { 'ambari_agent':
  serverhostname => "one.node",
  ownhostname    => "two.node",
  repo => 'http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo'
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_agent']

