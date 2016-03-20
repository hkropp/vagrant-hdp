include interfering_services
include ntp

class {'etchosts':
    ownhostname => $ownhostname
}

# Install and enable ambari agent
class { 'ambari_agent':
  ownhostname    => $ownhostname,
  serverhostname => $ambarihostname,
  ambari => $hdp_ambari,
  os => $hdp_os,
}

# Establish ordering
Class['interfering_services'] 
-> Class['ntp']
-> Class['etchosts']
-> Class['ambari_agent'] 
