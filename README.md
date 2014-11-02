vagrant-hdp
===========

A collection of Vagrant scripts to setup HDP clusters.

## Prerequisite

1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](https://docs.vagrantup.com/v2/installation/)
3. Vagrant Plugins:
* [Vagrant Hosts](https://github.com/adrienthebo/vagrant-hosts)
    vagrant plugin install vagrant-hosts
* [Vagrant Cachier (for Repo caching)](https://github.com/fgrehm/vagrant-cachier)
    vagrant plugin install vagrant-cachier
* Vagrant Openstack (optional)

## Environments
* ### VirtualBox ###
** HDP 2.1 Nodes: 1 - hdp21-n1-centos6-puppet
** HDP 2.1 Nodes: 3 - hdp21-n3-centos6-puppet
** HDP 2.2 Nodes: 1 - hdp22-n1-centos6-puppet
** HDP 2.2 Nodes: 3 - hdp22-n3-centos6-puppet

