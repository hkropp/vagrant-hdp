# Turn off interfering services
include interfering_services

# Install and enable ntp
include ntp

# Ensure that servers can find themselves even in absence of dns
class { 'etchosts':
  ownhostname => 'one.node'
}

class { 'ambari_agent':
  serverhostname => "one.node",
  ownhostname    => "three.node",
  repo => 'http://s3.amazonaws.com/dev.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo'
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_agent']
