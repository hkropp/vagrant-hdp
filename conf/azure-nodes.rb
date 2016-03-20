[
    {
        :name => "n1-hwx-hdp22-demo", 
        :manifest_file => "ambari-server.pp",
        :tcp_endpoints => "8080,8443,10000,10001,4040,4041,9083,8020,50070,50075,6080,8881,8882,8883,8884,8885,8886,61616,6667,2181,8081,8082,8083,8084", 
        :azure_vm_image => "HDP-CentOS-66-v3",
        :azure_vm_size => "A6" # Allowed values are 'ExtraSmall,Small,Medium,Large,ExtraLarge,A6,A7' http://msdn.microsoft.com/en-us/library/azure/dn197896.aspx   
    },
    {
        :name => "n2-hwx-hdp22-demo",
        :manifest_file => "ambari-agent.pp",
        :tcp_endpoints => "8443,4040,4041,9083,8020,50070,50075",
        :azure_vm_image => "HDP-CentOS-66-v3",
        :azure_vm_size => "A6" # Allowed values are 'ExtraSmall,Small,Medium,Large,ExtraLarge,A6,A7' http://msdn.microsoft.com/en-us/library/azure/dn197896.aspx   
    },
    {
        :name => "n3-hwx-hdp22-demo",
        :manifest_file => "ambari-agent.pp",
        :tcp_endpoints => "8443,4040,4041,9083,8020,50070,50075",
        :azure_vm_image => "HDP-CentOS-66-v3",
        :azure_vm_size => "A6" # Allowed values are 'ExtraSmall,Small,Medium,Large,ExtraLarge,A6,A7' http://msdn.microsoft.com/en-us/library/azure/dn197896.aspx   
    }
]
