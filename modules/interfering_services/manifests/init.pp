
class interfering_services {
  # Disable Package KIT
  file { 'packageKit':
    path    => "/etc/yum/pluginconf.d/refresh-packagekit.conf",
    ensure  => "present",
    replace => true,
    content => " enabled=0"
  }

  # Stop IP Tables
  exec { "stop_ip_tables":
    path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
    command => "service iptables stop"
  }
  
   exec { "stop_ip_tables6":
    path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
    command => "service ip6tables stop"
  }
}