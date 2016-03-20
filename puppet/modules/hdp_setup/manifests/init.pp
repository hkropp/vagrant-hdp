class hdp_setup($jdk_version =  "jdk1.8.0_60")  {
    Exec {
        path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
    }

    exec { "rm -f /etc/alternatives/java": }
    exec { "ln -s /usr/jdk64/$jdk_version/bin/java /etc/alternatives/java":
        require => Exec['rm -f /etc/alternatives/java']
    }

    exec { "rm -f /etc/alternatives/keytool": }
    exec { "ln -s /usr/jdk64/$jdk_version/bin/keytool /etc/alternatives/keytool":
        require => Exec['rm -f /etc/alternatives/keytool']
    }
}
