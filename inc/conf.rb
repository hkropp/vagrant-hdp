# 
# Configuring Vagrant HDP
#
DEBUG = true

VIRTUAL_BOX_PROVIDER = "virtualbox"

# supported
SUPPORTED_OS = ["centos6","centos7"]
SUPPORTED_AMBARI_VERSIONS = ["1.2.1.2", "1.2.2.3", "1.2.2.4", "1.2.2.5", "1.2.3.6", "1.2.3.7", "1.2.4.9", "1.2.5.17", "1.4.1.25", "1.4.1.61", "1.4.2.104", "1.4.3.38", "1.4.4.23", "1.5.0", "1.5.1", "1.6.0", "1.6.1", "1.7.0", "2.0.0", "2.0.1", "2.1.0", "2.1.1", "2.1.2", "2.2.0.0"]
SUPPORTED_HDP_STACKS = ["2.0", "2.0.6", "2.1", "2.2", "2.3"]
SUPPORTED_HDP_UPDATES = ["2.1.3.0","2.0.10.0","2.0.11.0","2.0.12.0","2.0.13.0","2.0.5.0","2.0.6.0","2.0.6.1","2.1.10.0","2.1.2.0","2.1.3.0","2.1.4.0","2.1.5.0","2.1.7.0","2.2.4.2","2.2.4.4","2.2.6.0","2.3.0.0", "2.3.2.0", "2.3.4.0"]
SUPPORTED_HDP_UTIL = ["1.0.1.14","1.1.0.15","1.1.0.16","1.1.0.17","1.1.0.18","1.1.0.19","1.1.0.20"]
 
# default HDP update for stack
DEFAULT_HDP_STACK_UPDATE = {}
DEFAULT_HDP_STACK_UPDATE["2.1"] = "2.1.3.0"
DEFAULT_HDP_STACK_UPDATE["2.2"] = "2.2.4.2"

# default HDP util for update
DEFAULT_HDP_UPDATE_UTIL = {}
DEFAULT_HDP_UPDATE_UTIL["2.1.3.0"] = "1.1.0.17"
DEFAULT_HDP_UPDATE_UTIL["2.2.4.2"] = "1.1.0.20"

class VagrantHdp
    
#    def initialize
#        # Setting some defaults
#        @hdp_ambari         = "1.6.0"
#        @hdp_os             = "centos6"
#        @hdp_stack          = "2.1"
#        @hdp_update         = "2.1.3.0"
#        @hdp_util           = "1.1.0.17"
#        @vagrant_provider   = VIRTUAL_BOX_PROVIDER
#    end

#    def hdp_args()
#        if !ARGV.index("--hdp-help").nil?
#            usage
#        end
#        arg_hdp_ambari_idx = ARGV.index("--hdp-ambari")
#        arg_hdp_os_idx = ARGV.index("--hdp-os")
#        arg_hdp_stack = ARGV.index("--hdp-stack")
#        arg_hdp_update = ARGV.index("--hdp-update")
#        arg_hdp_util = ARGV.index("--hdp-util")
#        arg_hdp_vagrant_provider = ARGV.index("--hdp-vagrant-provider")
#    
#        if !arg_hdp_ambari_idx.nil?
#            @hdp_ambari = ARGV.at(arg_hdp_ambari_idx+1)
#        end
#        if !arg_hdp_os_idx.nil?
#            @hdp_os = ARGV.at(arg_hdp_ambari_idx+1)
#        end
#        if !arg_hdp_stack.nil?
#            @hdp_stack = ARGV.at(arg_hdp_stack+1)
#        end
#        if !arg_hdp_update.nil?
#            @hdp_update = ARGV.at(arg_hdp_update+1)
#        else
#            @hdp_update = DEFAULT_HDP_STACK_UPDATE[@hdp_stack]
#        end
#        if !arg_hdp_util.nil?
#            @hdp_util = ARGV.at(arg_hdp_util+1)
#        else
#            @hdp_util = DEFAULT_HDP_UPDATE_UTIL[@hdp_update]
#        end
#        if !arg_hdp_vagrant_provider.nil?
#            @vagrant_provider = ARGV.at(arg_hdp_vagrant_provider+1)
#        end
#
#        hdp_args_validate
#    end

#    def usage
#        puts "Arguments:\n\t--hdp-ambari\n\t--hdp-os\n\t--hdp-stack\n\t--hdp-update\n\t--hdp-util\n\t--hdp-vagrant-provider"
#        Process.exit
#    end

#    def info
#        puts "HDP_AMBARI: #{@hdp_ambari}"
#        puts "OS: #{@hdp_os}"
#        puts "HDP_STACK: #{@hdp_stack}"
#        puts "HDP_UPDATE: #{@hdp_update}"
#        puts "HDP_UTIL: #{@hdp_util}"
#        puts "VAGARNT_PROVIDER: #{@vagrant_provider}"
#    end

    def validate(hdp_conf)
        if !SUPPORTED_AMBARI_VERSIONS.include? hdp_conf[:hdp_ambari]
            puts "ERROR: Not supported Ambari version: '#{hdp_conf[:hdp_ambari]}' Supported are: #{SUPPORTED_AMBARI_VERSIONS}"
            Process.exit
        end
        if !SUPPORTED_OS.include? hdp_conf[:hdp_os]
            puts "ERROR: Not supported OS: '#{hdp_conf[:hdp_os]}' Supported OS are: #{SUPPORTED_OS}" 
            Process.exit    
        end
        if !SUPPORTED_HDP_STACKS.include? hdp_conf[:hdp_stack]
            puts "ERROR: Not supported HDP Stacks: '#{hdp_conf[:hdp_stack]}' Supported HDP Stacks are: #{SUPPORTED_HDP_STACKS}"
            Process.exit
        end
        if !SUPPORTED_HDP_UPDATES.include? hdp_conf[:hdp_update]
            puts "ERROR: Not supported HDP Updates: '#{hdp_conf[:hdp_update]}' Supported HDP Stacks are: #{SUPPORTED_HDP_UPDATES}"
            Process.exit
        end
    end

    def ambari_repo_urli(hdp_conf)
        stack = "2.x"
        if hdp_conf[:hdp_ambari].start_with?('1')
            stack = "1.x"
        end
        return "http://public-repo-1.hortonworks.com/ambari/#{hdp_conf[:hdp_os]}/#{stack}/updates/#{hdp_conf[:hdp_ambari]}/ambari.repo"
    end

    ##
    # SETTERS / GETTERS
    ## 
#    def hdp_ambari
#        @hdp_ambari
#    end

#    def hdp_os
#        @hdp_os
#    end
        
#    def hdp_stack
#        @hdp_stack
#    end

#    def hdp_udpate
#        @hdp_update
#    end

#    def hdp_util
#        @hdp_util
#    end
    
#    def vagrant_provider
#        @vagrant_provider
#    end
end
