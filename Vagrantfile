# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/centos-6.5-64-puppet"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
  
  config.vm.define :one do |one| 
    one.vm.hostname = "one.cluster"
    one.vm.network :private_network, ip: "192.168.0.101"
    one.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 2048]
    end

    one.vm.network "forwarded_port", guest: 8080, host: 8080

    one.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifest"
      puppet.module_path = "modules"
      puppet.manifest_file = "one.pp"
    end
  end

  config.vm.define :two do |two| 
    two.vm.hostname = "two.cluster"
    two.vm.network :private_network, ip: "192.168.0.102"
    two.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 2048]
    end

    two.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifest"
      puppet.module_path = "modules"
      puppet.manifest_file = "two.pp"
    end
  end

  config.vm.define :three do |three| 
    three.vm.hostname = "three.cluster"
    three.vm.network :private_network, ip: "192.168.0.103"
    three.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 2048]
    end

    three.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifest"
      puppet.module_path = "modules"
      puppet.manifest_file = "three.pp"
    end
  end

end
