class kerberos($krb5_kdc="one.hdp", $krb5_realm="MYCORP.NET") {
  
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] 
  }

  package { ['krb5-server', 'krb5-libs', 'krb5-workstation']:
    ensure  => present,
  }

  exec { 'install_rng':
    command => 'yum -y install rng-tools',
  }

  file { "/etc/krb5.conf":
    owner => root,
    group => root,
    mode => "755",
    replace => true,
    content => epp("kerberos/krb5.conf.epp", {"krb5_kdc" => $krb5_kdc, "krb5_realm" => $krb5_realm}),
    require => Package[['krb5-server', 'krb5-libs', 'krb5-workstation']],
  }

  file { "/var/kerberos/krb5kdc/kdc.conf":
    owner => root,
    group => root,
    mode => "755",
    replace => true,
    content => epp("kerberos/kdc.conf.epp", {"krb5_realm" => $krb5_realm}),
    require => File["/etc/krb5.conf"],
  }

  file { "/var/kerberos/krb5kdc/kadm5.acl":
    owner => root,
    group => root,
    mode => "755",
    replace => true,
    content => epp("kerberos/kadm5.acl.epp", {"krb5_kdc" => $krb5_kdc, "krb5_realm" => $krb5_realm}),
    require => File["/var/kerberos/krb5kdc/kdc.conf"],
  }

  service {"rngd": # "start_rng":
    ensure => "running",
    #command => "/etc/init.d/rngd start",
    require => Exec['install_rng'],
  }
 
  exec {"create_kdb5":
    command => "kdb5_util create -s -P hadoop",
    creates => "/var/kerberos/krb5kdc/principal",
    require => Service["rngd"], # Exec["start_rng"],
  }

  exec {"create_krb5_adm":
    command => 'kadmin.local -q "addprinc -pw hadoop hdp/admin"',
    require => Exec["create_kdb5"],
  }

  service {"kadmin":
    ensure => "running",
    require => Exec["create_krb5_adm"],
  }

  service {"krb5kdc":
    ensure => "running",
    require => Exec["create_krb5_adm"],
  }

  #exec {"stop_rng":
  #  command => "/etc/init.d/rngd stop",
  #  require => Exec["create_krb5_adm"],
  #} 
}
