class ambari_server ($repo) {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

  # Ambari Repo
  exec { 'get-ambari-server-repo':
    command => "wget ${repo}", 
    cwd     => '/etc/yum.repos.d/',
    creates => '/etc/yum.repos.d/ambari.repo',
    user    => root
  }

  # Ambari Server
  package { 'ambari-server':
    ensure  => present,
    require => Exec[get-ambari-server-repo]
  } -> 
  
  augeas { 'repolist.xml':
    lens => "Xml.lns",
    incl => '/var/lib/ambari-server/resources/stacks/HDP/2.2/repos/repoinfo.xml',
    onlyif => "match dir[. = '/var/lib/ambari-server/resources/stacks/HDP/2.2/repos'] size != 0",
    changes => [
      "set reposinfo/latest/#text http://henning.kropponline.de/files/hdpqe_urlinfo.json",
      "set reposinfo/os[#attribute/type='redhat6']/repo[repoid/#text='HDP-2.2']/baseurl/#text http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Champlain-Preview/2.2.0.0-6/centos6",
      "set reposinfo/os[#attribute/type='redhat6']/repo[repoid/#text='HDP-UTILS-1.1.0.20']/baseurl/#text http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.19/repos/centos6"
    ]
  }

  exec { 'ambari-setup':
    command => "ambari-server setup -s",
    user    => root,
    require => Package[ambari-server]
  }

  service { 'ambari-server':
    ensure  => running,
    require => [Package[ambari-server], Exec[ambari-setup]],
    start   => Exec[ambari-server-start]
  }

  exec { 'ambari-server-start':
    command => "ambari-server start",
    require => Service[ambari-server],
    onlyif  => 'ambari-server status | grep "not running"'
  }
}
