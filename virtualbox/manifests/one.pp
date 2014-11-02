include interfering_services
include ntp

class {'etchosts':
    ownhostname => $ownhostname
}

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
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_server'] -> Class['ambari_agent']
