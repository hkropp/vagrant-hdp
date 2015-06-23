class hdp_appstudio {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] 
  }

  package {'install-git':
    ensure => present,
    name => 'git',
  }

  exec {'get-appstudio':
    command => 'wget http://henning.kropponline.de/files/HDPAppStudio-bin-2.2.0.0-2041.tar',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/HDPAppStudio-bin-2.2.0.0-2041.tar',
    user => vagrant,
    require => Package[install-git]
  }

  exec { 'untar-appstudio':
    command => 'tar xf HDPAppStudio-bin-2.2.0.0-2041.tar', 
    cwd     => '/home/vagrant',
    creates => '/home/vagrant/install.sh',
    user    => vagrant,
    require => Exec[get-appstudio]
  }

  exec {'install-appstudio':
    command => '/home/vagrant/install.sh',
    cwd => '/home/vagrant',
    creates => '/var/lib/ambari-server/resources/views/HDPAppStudio-2.2.0.0-2041-distribution.jar',
    user => root,
    require => Exec[untar-appstudio]
  }
}
