[
    {
        :name => "one.hdp", 
        :cpu => 2, 
        :mem => 8192, 
        :ip => "192.168.33.100", 
        :manifest_file => "one.pp",
        :tcp_endpoints => "8080,8443,10000,10001",                       # comma-seperated list of ports to forward
        :azure_vm_image => "HDP-CentOS-66-v2",
        :azure_vm_size => "A6",                         # Allowed values are 'ExtraSmall,Small,Medium,Large,ExtraLarge,A6,A7' http://msdn.microsoft.com/en-us/library/azure/dn197896.aspx
        :azure_service_name => "hwx-hdp-cluster",
        :azure_ssh_port => 22
    }
]
