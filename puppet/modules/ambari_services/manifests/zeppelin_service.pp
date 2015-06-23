class ambari_services::zeppelin_service {
  
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
  }

  package { 'git':
    ensure  => present,
  }

  # Ambari Repo
  exec { 'clone-zeppelin-service':
    command => 'git clone https://github.com/abajwa-hw/zeppelin-stack.git',
    cwd     => '/var/lib/ambari-server/resources/stacks/HDP/2.2/services',
    creates => '/var/lib/ambari-server/resources/stacks/HDP/2.2/services/zeppelin-stack',
    user    => root,
    require => Package[git]
  }

  # Ambari Server
  exec { 'ambari-server-restart-zeppelin-service':
    command => 'ambari-server restart',
    user => root,
    require => Exec[clone-zeppelin-service]
  }

}
