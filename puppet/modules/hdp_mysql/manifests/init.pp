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
                'innodb-file-per-table' => 1,
            }
        }
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
