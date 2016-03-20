[
    {
        :name => "one.hdp", 
        :node_env => "ambari_server",
        :cpu => 8, 
        :mem => 9216, 
        :ip => "192.168.33.100", 
        :manifest_file => "one.pp",
        :tcp_endpoints => "8080,8443,10000,10001,4040,4041,9083,8020,50070,50075,6080,8881,8882,8883,8884,8885,8886,61616,6667,2181,8081,8082,8083,8084,50470,50475,88,749", 
        :azure_vm_image => "HDP-CentOS-66-v3",
        :azure_vm_size => "A6", # Allowed values are 'ExtraSmall,Small,Medium,Large,ExtraLarge,A6,A7' http://msdn.microsoft.com/en-us/library/azure/dn197896.aspx
        :azure_mgmt_certificate => "/Users/hkropp/.ssh/azure_mgmt.pem",
        :azure_mgmt_endpoint => "https://management.core.windows.net",
        :azure_subscription_id => "xxxx-xxxxx-xxxx",
        :azure_cloud_service_name => "hdp-vagrant-demo",
    }
]
