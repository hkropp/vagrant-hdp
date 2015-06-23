class ambari_server ($ambari="1.6.0", $os="centos6", $stack="2.1", $update="2.1.3.0", $util="1.1.0.17") {
 
   
  $ambari_path = $ambari ? {
    /^1.*/ => '1.x',
    /^2.*/ => '2.x'
  }
    
  $stack_path = $stack ? {
    /^1.*/ => '1.x',
    /^2.*/ => '2.x'
  }
   
  $os_type = $os ? {
    'centos6' => 'redhat6',
    'centos5' => 'redhat5', 
    default => $os,
  }
 
  $update_path = $update ? {
    /.*-latest/ => $update,
    default =>  "updates/${update}"
  }
    
    notice("Ambari server config: OS=${os}, OS_Type=${os_type}, Stack=${stack}, Stack_Path=${stack_path}, Ambari=${ambari}, Ambari_Path=${ambari_path}, Update=${update}, Update_Path=${update_path}, Util=${util}")

  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"]
  }

  # Ambari Repo
  exec { 'get-ambari-server-repo':
    command => "wget http://public-repo-1.hortonworks.com/ambari/${os}/${ambari_path}/updates/${ambari}/ambari.repo", 
    cwd     => '/etc/yum.repos.d/',
    creates => '/etc/yum.repos.d/ambari.repo',
    user    => root,
  }

  # Ambari Server
  package { 'ambari-server':
    ensure  => present,
    require => Exec[get-ambari-server-repo]
  }

  augeas { 'repolist-hdp':
    require => Package[ambari-server],
    lens => "Xml.lns",
    incl => "/var/lib/ambari-server/resources/stacks/HDP/${stack}/repos/repoinfo.xml",
    onlyif => [
      "match reposinfo/os[#attribute/family='${os_type}']/repo[repoid/#text='HDP-${stack}']/baseurl size == 1",
      "get reposinfo/os[#attribute/family='${os_type}']/repo[repoid/#text='HDP-${stack}']/baseurl/#text != 'http://public-repo-1.hortonworks.com/HDP/${os}/${stack_path}/${update_path}/'",
    ],
    changes => [
      "set reposinfo/os[#attribute/family='${os_type}']/repo[repoid/#text='HDP-${stack}']/baseurl/#text http://public-repo-1.hortonworks.com/HDP/${os}/${stack_path}/${update_path}/",
    ]
  }
  
  augeas { 'repolist-hdp-utils':
    require => Package[ambari-server],
    lens => "Xml.lns",
    incl => "/var/lib/ambari-server/resources/stacks/HDP/${stack}/repos/repoinfo.xml",
    onlyif => [
      "match reposinfo/os[#attribute/family='${os_type}']/repo[reponame/#text='HDP-UTILS']/baseurl size == 1",
      "get reposinfo/os[#attribute/family='${os_type}']/repo[reponame/#text='HDP-UTILS']/baseurl/#text != 'http://public-repo-1.hortonworks.com/HDP-UTILS-${util}/repos/${os}/'",
    ],
    changes => [
      "set reposinfo/os[#attribute/family='${os_type}']/repo[reponame/#text='HDP-UTILS']/baseurl/#text http://public-repo-1.hortonworks.com/HDP-UTILS-${util}/repos/${os}/"
    ]
  }

  exec { 'ambari-setup':
    command => "ambari-server setup -s",
    user    => root,
    require => [Augeas[repolist-hdp], Augeas[repolist-hdp-utils]],
    #require => Package[ambari-server],
    timeout => 2600     # increase timeout for jdk download, use proxy
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

  exec { "cp-mysql-connector":
    command => "cp /usr/share/java/mysql-connector-java.jar /var/lib/ambari-server/resources/mysql-jdbc-driver.jar",
    creates => "/var/lib/ambari-server/resources/mysql-jdbc-driver.jar",
    onlyif => [
      "test -f /usr/share/java/mysql-connector-java.jar",
      "test -d /var/lib/ambari-server/resources/"
    ],
    require => Exec['ambari-setup']
  }
}
