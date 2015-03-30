include interfering_services
include ntp

class {'etchosts':
    ownhostname => $ownhostname
}

class { 'ambari_server':
  repo => $hdp_ambari_repo
}

class { 'ambari_agent':
  ownhostname    => $ownhostname,
  serverhostname => $ambarihostname,
  repo => $hdp_ambari_repo
}

class {'::mysql::server':
  root_password => 'root',
  override_options => {
      'mysqld' => {
          'bind-address' => '0.0.0.0', 
          'default-storage-engine' => 'innodb', 
          'innodb-file-per-table' => 1
      }
  },
  databases => {
    'hive' => {
        ensure => 'present',
        charset => 'utf8'
    },
    'oozie' => {
        ensure => 'present',
        charset => 'utf8'
    }
  },
  users => {
    'hive@localhost' => {
      ensure => 'present',
      password_hash => '*FB73BCDD6050E0F3F73E0262950F4D9E0092769C', # hive123
    },
    'oozie@localhost' => {
        ensure => 'present',
        password_hash => '*F48D8C9FDE123A678CE26563F4E7F048ABA60C94', # oozie123
    },
  },
  grants => {
    'hive@localhost/hive.*' => {
      ensure => 'present',
      options => ['GRANT'],
      privileges => ['ALL'],
      table => 'hive.*',
      user => 'hive@localhost',
    },
    'oozie@localhost/oozie.*' => {
      ensure => 'present',
      options => ['GRANT'],
      privileges => ['ALL'],
      table => 'oozie.*',
      user => 'oozie@localhost',
    },
  }
}

class {'mysql::bindings':
  java_enable => true,
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['ambari_server'] -> Class['ambari_agent']
