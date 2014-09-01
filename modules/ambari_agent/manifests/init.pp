
class ambari_agent ($ownhostname, $serverhostname) {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }


  # Ambari Repo
  exec { 'get-ambari-agent-repo':
    command => "wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo",
    cwd     => '/etc/yum.repos.d/',
    creates => '/etc/yum.repos.d/ambari.repo',
    user    => root
  }

  # Ambari Agent
  package { 'ambari-agent':
    ensure  => present,
    require => Exec[get-ambari-agent-repo]
  }

  file_line { 'ambari-agent-ini-hostname':
    ensure  => present,
    path    => '/etc/ambari-agent/conf/ambari-agent.ini',
    line    => "hostname=${serverhostname}", # server host name
    match   => 'hostname=*',
    require => Package[ambari-agent]
  }

  exec { 'hostname':
    command => "hostname ${ownhostname}", # own host name
    user    => root
  }

  exec { 'ambari-agent-start':
    command => "ambari-agent start",
    user    => root,
    require => [Package[ambari-agent], Exec[hostname], File_line[ambari-agent-ini-hostname]],
    onlyif  => 'ambari-agent status | grep "not running"'
  }
}
