class hdp_mysql::oozie {
    include hdp_mysql

    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }

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
    
}   
