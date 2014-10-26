# Ensure that the machines in the cluster can find each other without DNS
class etchosts ($ownhostname) {
  host { 'host_one':
    name  => 'one.node',
    alias => ['one', 'one.node'],
    ip    => '192.168.0.100'
  }

  host { 'host_two':
    name  => 'two.node',
    alias => ['two', 'two.node'],
    ip    => '192.168.0.102'
  }

  host { 'host_three':
    name => 'three.node',
    alias => ['three', 'three.node'],
    ip => '192.168.0.103'
  }

  host { 'host_four':
    name => 'four.node',
    alias => ['four', 'four.node'],
    ip => '192.168.0.104'
  }

  file { 'agent_hostname':
    path    => "/etc/hostname",
    ensure  => present,
    replace => true,
    content => "${ownhostname}", # own hostname
    owner   => 1546
  }

  file { 'agent_sysconfig':
    path    => "/etc/sysconfig/network",
    ensure  => present,
    replace => true,
    content => "NETWORKING=yes \nHOSTNAME=${ownhostname}" # own hostname
  }
}
