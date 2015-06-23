# -*- mode: ruby -*-
# # vi: set ft=ruby :
require "./inc/conf.rb"

HDP_CONF_FILE = "conf/hdp.rb"
NODES_CONF_FILE = "conf/nodes.rb"

if !ARGV.index("--hdp-conf").nil?
    HDP_CONF_FILE = ARGV.at(arg_hdp_ambari_idx+1)
end
if !ARGV.index("--hdp-nodes").nil?
    NODES_CONF_FILE = ARGV.at(arg_hdp_ambari_idx+1)
end

vagrant_hdp = VagrantHdp.new

hdp_conf = eval(File.open(File.expand_path(HDP_CONF_FILE)).read)
nodes = eval(File.open(File.expand_path(NODES_CONF_FILE)).read)

vagrant_hdp.validate(hdp_conf)   

#puts hdp[:hdp_stack]
#Process.exit

# default and only box currently supported
BOX="puppetlabs/centos-6.5-64-puppet"
BOX_URL="http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
      
MANIFESTS_PATH='manifests'
MODULES_PATH='puppet/modules'

AMBARI_HOST_NAME = hdp_conf[:ambari_node]

VAGRANTFILE_API_VERSION = "2"

if hdp_conf[:vagrant_provider] == "virtualbox"

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
      config.vm.box = BOX
      config.vm.box_url = BOX_URL
      
      if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
      end
        
      nodes.each do |opts|
          config.vm.define opts[:name] do |node_config| 
            node_config.vm.hostname = "%s" % opts[:name].to_s
            node_config.vm.network :private_network, ip: opts[:ip]
            node_config.vm.provider :virtualbox do |vb|
                vb.name = "hdp_%s_%s_%s-%s" % [ hdp_conf[:hdp_stack], hdp_conf[:hdp_update], hdp_conf[:hdp_ambari], opts[:name].to_s]
                vb.customize ["modifyvm", :id, "--cpus", opts[:cpu] ] if opts[:cpu]
                vb.customize ["modifyvm", :id, "--ioapic", "on"]
                vb.customize ["modifyvm", :id, "--memory", opts[:mem] || 2048 ]
            end
    
            node_config.vm.provision :hosts do |provisioner|
                provisioner.autoconfigure = false
                provisioner.add_localhost_hostnames = false
                nodes.each do |n|
                    provisioner.add_host n[:ip], [n[:name], n[:name].split(".")[0]]
                end
            end
            
            opts[:tcp_endpoints].to_s.split(",").each do |vm_port|
                config.vm.network "forwarded_port", guest: Integer(vm_port), host: Integer(vm_port), auto_correct: true
            end
    
            node_config.vm.provision "puppet" do |puppet|
                puppet.manifests_path = MANIFESTS_PATH
                puppet.module_path = MODULES_PATH
                puppet.manifest_file = opts[:manifest_file].to_s
                puppet.facter = {
                    "ownhostname" => opts[:name],
                    "ambarihostname" => AMBARI_HOST_NAME,
                    "hdp_ambari" => hdp_conf[:hdp_ambari],
                    "hdp_os" => hdp_conf[:hdp_os], 
                    "hdp_stack" => hdp_conf[:hdp_stack],
                    "hdp_update" => hdp_conf[:hdp_update],
                    "hdp_util" => hdp_conf[:hdp_util],
                }
            end
          end
      end
    end

elsif hdp_conf[:vagrant_provider] == "azure"
    
    CLOUD_SERVICE_NAME=hdp_conf[:azure_cloud_service_name]

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
        config.vm.box = hdp_conf[:vagrant_provider]
        config.ssh.private_key_path = hdp_conf[:azure_ssh_private_key_file]
        config.ssh.username = hdp_conf[:azure_vm_user]

        nodes.each do |opts|
            config.vm.define opts[:name] do |config| 
                config.vm.provider :azure do |azure|
                    azure.mgmt_certificate = hdp_conf[:azure_mgmt_certificate]    
                    azure.mgmt_endpoint = hdp_conf[:azure_mgmt_endpoint]
                    azure.subscription_id = hdp_conf[:azure_subscription_id]
            
                    azure.storage_acct_name = hdp_conf[:azure_storage_acct_name]
                    
                    azure.vm_image = opts[:azure_vm_image] 
                    azure.vm_size = opts[:azure_vm_size]  # Allowed values are 'ExtraSmall,Small,Medium,Large,ExtraLarge,A6,A7' http://msdn.microsoft.com/en-us/library/azure/dn197896.aspx
                    azure.vm_user = hdp_conf[:azure_vm_user]
                    azure.vm_virtual_network_name = hdp_conf[:azure_vm_virtual_network_name] # opts[:vm_net].to_s
                    #azure.vm_virtual_network_ip = opts[:vm_ip]
                    #azure.vm_subnet_name = opts[:vm_subnet]
                    azure.vm_name = opts[:name].to_s
                    azure.vm_location = hdp_conf[:azure_vm_location] 

                    azure.cloud_service_name = "%s-%s" % [opts[:name], CLOUD_SERVICE_NAME]
            
                    azure.ssh_private_key_file = hdp_conf[:azure_ssh_private_key_file]
                    azure.ssh_certificate_file = hdp_conf[:azure_ssh_certificate_file]

                    azure.ssh_port = hdp_conf[:ssh_port]
                    azure.tcp_endpoints = opts[:tcp_endpoints]
                end

                config.vm.provision "puppet" do |puppet|        
                    puppet.manifests_path = MANIFESTS_PATH
                	puppet.module_path = MODULES_PATH
                	puppet.manifest_file = opts[:manifest_file].to_s
                	puppet.facter = {
                    	"ownhostname" => opts[:name],
                    	"ambarihostname" => AMBARI_HOST_NAME,
                    	"hdp_ambari" => hdp_conf[:hdp_ambari],
                    	"hdp_os" => hdp_conf[:hdp_os], 
                    	"hdp_stack" => hdp_conf[:hdp_stack],
                    	"hdp_update" => hdp_conf[:hdp_update],
                    	"hdp_util" => hdp_conf[:hdp_util],
                	}	
                end
            end
        end
    end
end
