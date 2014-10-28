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

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['ambari_server'] -> Class['ambari_agent']
