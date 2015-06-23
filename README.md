vagrant-hdp: Beyond HDP Sandbox
===========

Quickly setup devolping or demo cluster based on Hortonworks HDP Platform on multiple virtual host providers like Azure, Virtualbox, VMWare, Amazon Webservice, etc. (Currently only Azure and VirtualBox supported).

## Install

1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant (1.7+)](https://docs.vagrantup.com/v2/installation/)
3. Vagrant Plugins:
** [Vagrant Hosts](https://github.com/adrienthebo/vagrant-hosts)
   `vagrant plugin install vagrant-hosts`
** [Vagrant Cachier (for Repo caching)](https://github.com/fgrehm/vagrant-cachier)
   `vagrant plugin install vagrant-cachier`
4. `git clone git@github.com:hkropp/vagrant-hdp.git`

## Example
After installing [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://docs.vagrantup.com/v2/installation/) it should be enough to run `vagrant up` inside vagrant-hdp folder.
```
$ cd vagrant-hdp
$ vagrant up
```

By default the Vagrantfile will pick up the configuration under conf/hdp.rb and conf/nodes.rb.

### HDP Example Environment

The HDP environment can be configured using `conf/hdp.rb`:
```
{
    :hdp_ambari => "2.0.0",
    :hdp_os => "centos6",
    :hdp_stack => "2.2",
    :hdp_update => "2.2.4.2",
    :hdp_util => "1.1.0.20",
    :vagrant_provider => "virtualbox", # "azure",
    :ambari_node => "one.hdp", "n01-hdp-vagrant-demo.cloudapp.net",
}
```

### Node Setup

Multiple nodes can be configured using `conf/nodes.rb`:
```
[
    {
        :name => "n01", 
        :cpu => 8, 
        :mem => 9216, 
        :ip => "192.168.33.100", 
        :manifest_file => "one.pp",
        :tcp_endpoints => "8080,8443,10000,10001,4040,4041,9083,8020,50070,50075,6080,8881,8882", 
    }
]
```

### Node Manifest

By default this manifest is being used for the one node `manifest/one.pp`:
```
include interfering_services
include ntp
include hdp_mysql
include ambari_views::file_view
include ambari_views::hive_view
include ambari_views::capacity_scheduler_view
include ambari_services::zeppelin_service

class {'etchosts':
    ownhostname => $ownhostname
}

# Install and enable ambari server
class { 'ambari_server':
  ambari => $hdp_ambari,
  os => $hdp_os, 
  stack => $hdp_stack,
  update => $hdp_update,
  util => $hdp_util,
}

# Install and enable ambari agent
class { 'ambari_agent':
  ownhostname    => $ownhostname,
  serverhostname => $ambarihostname,
  ambari => $hdp_ambari,
  os => $hdp_os,
}

# Establish ordering
Class['interfering_services'] -> Class['ntp'] -> Class['etchosts'] -> Class['hdp_mysql'] -> Class['ambari_server'] -> Class['ambari_agent'] 
-> Class['ambari_views::file_view'] -> Class['ambari_views::hive_view'] -> Class['ambari_views::capacity_scheduler_view'] -> Class['ambari_services::zeppelin_service']
```

