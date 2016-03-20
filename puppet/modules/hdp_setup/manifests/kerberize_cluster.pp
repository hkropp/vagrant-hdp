class hdp_setup::blueprint_install($ambarihostname='one.hdp', $blueprint_name='n1-hdp-basic', $krb5_kdc='one.hdp', $krb5_realm='MYCORP.NET', ) {
    include hdp_setup
    
    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    exec { "/vagrant/bin/kerberize_cluster.py admin admin ${ambarihostname} 8080 ${krb5_kdc} ${krb5_realm} hdp/admin@MYCORP.NET hadoop": 
        timeout => 3600,
    }
}   
