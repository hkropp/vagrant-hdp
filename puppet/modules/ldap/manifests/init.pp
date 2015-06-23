include camptocamp-openldap 

# ldap model
class ldap {
    class { 'openldap::server': }
    openldap::server::database { 'dc=foo,dc=example.com':
      ensure => present,
    }
}
