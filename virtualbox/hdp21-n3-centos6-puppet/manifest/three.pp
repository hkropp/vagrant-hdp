# Turn off interfering services
include interfering_services

# Install and enable ntp
include ntp

class { 'ambari_agent':
  serverhostname => $ambarihostname,
  ownhostname    => $ownhostname,
  repo => $hdp_ambari_repo
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['ambari_agent']
