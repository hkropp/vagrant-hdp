class hdp_mysql::ranger {
    include hdp_mysql

    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }

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

}   
