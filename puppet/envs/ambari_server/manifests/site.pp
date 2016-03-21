include interfering_services
include ntp
include kerberos
include hdp_mysql::oozie
include hdp_mysql::hive
include hdp_mysql::ranger
include hdp_setup::hive_streaming
include hdp_setup::hdfs
include hdp_setup::phoenix
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

class {'hdp_setup::blueprint_install':
  blueprint_name => $blueprint_name,
}

class {'hdp_setup::kerberize_cluster':
  ambarihostname => $ambarihostname,
  blueprint_name => $blueprint_name,
  krb5_kdc => $krb5_kdc,
  krb5_realm => $krb5_realm,
}

# Establish ordering
Class['interfering_services']
-> Class['ntp'] 
-> Class['etchosts']
-> Class['kerberos']
-> Class['hdp_mysql::oozie']
-> Class['hdp_mysql::hive']
-> Class['hdp_mysql::ranger'] 
-> Class['ambari_server'] 
-> Class['ambari_agent']
-> Class['hdp_setup::blueprint_install']
-> Class['hdp_setup::hive_streaming']
-> Class['hdp_setup::hdfs']
-> Class['hdp_setup::phoenix']
-> Class['ambari_services::zeppelin_service']
-> Class['hdp_setup::kerberize_cluster']

