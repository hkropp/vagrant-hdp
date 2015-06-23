class ambari_views::file_view {
  
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
  }

  # Ambari Repo
  exec { 'get-ambari-file-view-jar':
    command => 'wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Views/tp1/files-0.1.0-tp1.jar',
    cwd     => '/var/lib/ambari-server/resources/views/',
    creates => '/var/lib/ambari-server/resources/views/files-0.1.0-tp1.jar',
    user    => root,
  }

  # Ambari Server
  exec { 'ambari-server-restart-file-view':
    command => 'ambari-server restart',
    user => root,
    require => Exec[get-ambari-file-view-jar]
  }

}
