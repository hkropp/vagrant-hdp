class hdp_mysql {
    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    class {'mysql::server':
        root_password => 'root',
        override_options => {
            'mysqld' => {
                'bind-address' => '0.0.0.0',
                'default-storage-engine' => 'innodb',
                'innodb-file-per-table' => 1
            }
        }
    }

    ######
    ## Hive
    ######
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

    ###
    # Oozie
    ## 
    mysql_database { 'oozie':
        ensure => 'present',
        charset => 'utf8',
        require => Class['mysql::server']
    }

    mysql_user {'oozie@localhost':
        ensure => 'present',
        password_hash => '*F48D8C9FDE123A678CE26563F4E7F048ABA60C94', # oozie123
        require => Mysql_database[oozie]
    }   
    
    mysql_grant { 'oozie@localhost/oozie.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'oozie.*',
        user       => 'oozie@localhost',
        require    => Mysql_user['oozie@localhost']
    }
    
    mysql_user {'oozie@%':
        ensure => 'present',
        password_hash => '*F48D8C9FDE123A678CE26563F4E7F048ABA60C94', #oozie123
        require => Mysql_database[oozie]
    }
    
    mysql_grant { 'oozie@%/oozie.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'oozie.*',
        user       => 'oozie@%',
        require    => Mysql_user['oozie@%']
    }

    ###
    # Ranger
    ## 
    mysql_database { 'ranger':
        ensure => 'present',
        charset => 'utf8',
        require => Class['mysql::server']
    }

    mysql_user {'ranger@localhost':
        ensure => 'present',
        password_hash => '*2D1DBE4DBB7C844A55C4A43D27EC57B1561C0280', # ranger123
        require => Mysql_database[ranger]
    }   
    
    mysql_grant { 'ranger@localhost/ranger.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'ranger.*',
        user       => 'ranger@localhost',
        require    => Mysql_user['ranger@localhost']
    }
    
    mysql_user {'ranger@%':
        ensure => 'present',
        password_hash => '*2D1DBE4DBB7C844A55C4A43D27EC57B1561C0280', #ranger123
        require => Mysql_database[ranger]
    }
    
    mysql_grant { 'ranger@%/ranger.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'ranger.*',
        user       => 'ranger@%',
        require    => Mysql_user['ranger@%']
    }

    class { 'mysql::bindings':
        java_enable => true,
        require => Class['mysql::server']
    }

    exec { "cp-jdbc-connector":
        command => "cp /usr/share/java/mysql-connector-java.jar /var/lib/ambari-server/resources/mysql-jdbc-driver.jar",
        creates => "/var/lib/ambari-server/resources/mysql-jdbc-driver.jar",
        onlyif => [ 
            "test -f /usr/share/java/mysql-connector-java.jar", 
            "test -d /var/lib/ambari-server/resources/"
        ],
        require => Class['mysql::bindings']
    }
}   
