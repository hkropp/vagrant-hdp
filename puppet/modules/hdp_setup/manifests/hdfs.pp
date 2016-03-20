class hdp_setup::hdfs {
    include hdp_setup

    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }

    exec { 'su - hdfs -c "hdfs dfs -mkdir /user/vagrant"': }
    exec { 'su - hdfs -c "hdfs dfs -chown vagrant:vagrant /user/vagrant"':
        require => Exec['su - hdfs -c "hdfs dfs -mkdir /user/vagrant"']
    }
    
}   
