class hdp_setup::blueprint_install($blueprint_name='n1-hdp-basic') {
    include hdp_setup
    
    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    exec { "/vagrant/bin/install_cluster.sh ${blueprint_name}": 
        timeout => 3600,
    }
}   
