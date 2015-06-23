vagrant-hdp: Beyond HDP Sandbox
===========

Quickly setup devolping or demo cluster based on Hortonworks HDP Platform on multiple virtual host providers like Azure, Virtualbox, VMWare, Amazon Webservice, etc. (Currently only Azure and VirtualBox supported).

## Install

1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant (1.7+)](https://docs.vagrantup.com/v2/installation/)
3. Vagrant Plugins:
** [Vagrant Hosts](https://github.com/adrienthebo/vagrant-hosts)
   ´´´vagrant plugin install vagrant-hosts´´´
** [Vagrant Cachier (for Repo caching)](https://github.com/fgrehm/vagrant-cachier)
   ´´´vagrant plugin install vagrant-cachier´´´
4. ´´´git clone git@github.com:hkropp/vagrant-hdp.git´´´

## Example
After installing [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://docs.vagrantup.com/v2/installation/) it should be enough to run ´´´vagrant up´´´ inside vagrant-hdp folder.
´´´
$ cd vagrant-hdp
$ vagrant up
´´´

By default the Vagrantfile will pick up the configuration under conf/hdp.rb and conf/nodes.rb.

### HDP Example Environment

