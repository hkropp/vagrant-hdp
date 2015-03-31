class knox {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

  # Knox installation
  exec { 'knox-install':
    command => "zypper install knox", 
    cwd     => '/root',
    creates => '/usr/lib/knox',
    user    => root
    before  => Exec['knox-setup'] 
  }

  # Knox setup
  exec { 'knox-setup':
    command => "su -l knox -c gateway.sh setup <<< `echo "\n\n"`", 
    cwd => '/usr/lib/knox/bin',
  }
  
  service { 'gateway.sh':
    ensure  => running,
    require => Exec[knox-setup],
    start   => Exec[gateway.sh-start]
  }

  exec { 'gateway.sh-start':
    command => "su -l knox -c gateway.sh start",
    cwd => /user/lib/knox/bin,
    require => Service[gateway.sh],
    onlyif  => 'gateway.sh status | grep "not running"'
  }
}
