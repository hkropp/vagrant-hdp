class hdp_mysql::hive {
    include mysql::server

    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    mysql_database { 'hive':
        ensure  => 'present',
        charset => 'utf8',
        require => Class['mysql::server']
    }

    mysql_user {'hive@localhost':
        ensure => 'present',
        password_hash => '*FB73BCDD6050E0F3F73E0262950F4D9E0092769C',     
        require => Mysql_database[hive]
    }

    mysql_grant { 'hive@localhost/hive.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'hive.*',
        user       => 'hive@localhost',
        require    => Mysql_user['hive@localhost']
    }

    mysql_user {'hive@%':
        ensure => 'present',
        password_hash => '*FB73BCDD6050E0F3F73E0262950F4D9E0092769C',
        require => Mysql_database[hive]
    }   
    
    mysql_grant { 'hive@%/hive.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'hive.*',
        user       => 'hive@%',
        require    => Mysql_user['hive@%']
    }

}   
