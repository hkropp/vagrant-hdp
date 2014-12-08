include interfering_services
include ntp

class {'etchosts':
    ownhostname => $ownhostname
}

class { 'ambari_agent':
  serverhostname => $ambarihostname,
  ownhostname    => $ownhostname,
  repo => $hdp_ambari_repo
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_agent']

