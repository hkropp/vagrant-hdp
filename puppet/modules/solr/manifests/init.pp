class solr {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] 
  }

  user {'create-solr-user':
    ensure => 'present',
    name => 'solr',
    home => '/home/solr'
  }

  exec {'make-solr-dir':
    command => 'mkdir /opt/solr && chown solr:solr /opt/solr',
    creates => '/opt/solr',
    user => root,
    require => User[create-solr-user]
  }

  exec { 'get-solr-tgz':
    command => 'wget http://mirror.reverse.net/pub/apache/lucene/solr/4.7.2/solr-4.7.2.tgz', 
    cwd     => '/opt/solr',
    creates => '/opt/solr/solr-4.7.2.tgz',
    user    => solr,
    require => Exec[make-solr-dir]
  }

  exec {'get-lucidworks-hadoop-jar':
    command => 'wget http://henning.kropponline.de/files/hadoop-lws-job-2.0.1-0-0-hadoop2.jar && ln -s hadoop-lws-job-2.0.1-0-0-hadoop2.jar lucidworks-hadoop-lws-job-1.3.0.jar',
    cwd => '/opt/solr',
    creates => '/opt/solr/hadoop-lws-job-2.0.1-0-0-hadoop2.jar',
    user => solr,
    require => Exec[get-solr-tgz]
  }

  exec { 'untar-solr-tgz':
    command => 'tar xfz solr-4.7.2.tgz && ln -s /opt/solr/solr-4.7.2 /opt/solr/solr',
    cwd => '/opt/solr',
    creates => '/opt/solr/solr-4.7.2',
    user => solr,
    require => Exec[get-lucidworks-hadoop-jar]
  }
}
