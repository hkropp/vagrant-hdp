class ambari_views::capacity_scheduler_view {
  
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
  }

  # Ambari Repo
  exec { 'get-ambari-capacity-scheduler-view-jar':
    command => 'wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Views/tp1/capacity-scheduler-0.3.0-tp1.jar',
    cwd     => '/var/lib/ambari-server/resources/views/',
    creates => '/var/lib/ambari-server/resources/views/capacity-scheduler-0.3.0-tp1.jar',
    user    => root,
  }

  # Ambari Server
  exec { 'ambari-server-restart-capacity-scheduler-view':
    command => 'ambari-server restart',
    user => root,
    require => Exec[get-ambari-capacity-scheduler-view-jar]
  }

}
