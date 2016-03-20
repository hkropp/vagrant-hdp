class hdp_setup::blueprint_install($ambarihostname='one.hdp',    ) {
    include hdp_setup
    
    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    exec { "/vagrant/bin/kerberize_cluster.py admin admin ${ambarihostname}": 
        timeout => 3600,
    }
}   
