include interfering_services
include ntp
include hdp_mysql
include ambari_views::file_view
include ambari_views::hive_view
include ambari_views::capacity_scheduler_view
include ambari_services::zeppelin_service

class {'etchosts':
    ownhostname => $ownhostname
}

# Install and enable ambari server
class { 'ambari_server':
  ambari => $hdp_ambari,
  os => $hdp_os, 
  stack => $hdp_stack,
  update => $hdp_update,
  util => $hdp_util,
}

# Install and enable ambari agent
class { 'ambari_agent':
  ownhostname    => $ownhostname,
  serverhostname => $ambarihostname,
  ambari => $hdp_ambari,
  os => $hdp_os,
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['hdp_mysql'] -> Class['ambari_server'] -> Class['ambari_agent'] 
-> Class['ambari_views::file_view'] -> Class['ambari_views::hive_view'] -> Class['ambari_views::capacity_scheduler_view'] -> Class['ambari_services::zeppelin_service']
