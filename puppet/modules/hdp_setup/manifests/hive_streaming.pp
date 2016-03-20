class hdp_setup::hive_streaming {

    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    file { "/tmp/hive":
        ensure => present,
        mode   => '777',
    }

    exec { 'su - hdfs -c "hdfs dfs -chmod 777 /tmp/hive "':
        require => File['/tmp/hive']
    }

}   
