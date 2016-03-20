class hdp_setup::phoenix {
    include hdp_setup

    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }
    
    package { "phoenix":
        ensure => "installed"
    }
}
