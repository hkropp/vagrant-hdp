class ambari_views::hive_view {
  
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
  }

  # Ambari Repo
  exec { 'get-ambari-hive-view-jar':
    command => 'wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Views/tp1/hive-0.2.0-tp1.jar',
    cwd     => '/var/lib/ambari-server/resources/views/',
    creates => '/var/lib/ambari-server/resources/views/hive-0.2.0-tp1.jar',
    user    => root,
  }

  # Ambari Server
  exec { 'ambari-server-restart-hive-view':
    command => 'ambari-server restart',
    user => root,
    require => Exec[get-ambari-hive-view-jar]
  }

}
