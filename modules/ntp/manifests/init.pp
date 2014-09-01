class ntp {
  package { 'ntp':
    name   => "ntp",
    ensure => present
  }

  service { 'ntp-services':
    name   => "ntpd",
    ensure => running,
    require => Package[ntp] 
  }
}
