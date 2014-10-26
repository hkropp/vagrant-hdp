# VM-Configuration of the ambari server. It functions as the name node and resource manager.

# Turn off interfering services
include interfering_services

# Install and enable ntp
include ntp

# Ensure that servers can find themselves even in absence of dns
class { 'etchosts':
  ownhostname => 'one.node'
}

# Install and enable ambari server
class { 'ambari_server':
  repo => 'http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo'
}

# Install and enable ambari agent
class { 'ambari_agent':
  ownhostname    => 'one.node',
  serverhostname => 'one.node',
  repo => 'http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo'
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_server'] -> Class['ambari_agent']
