#
# Cookbook Name:: contrail
# Recipe:: prov_vrouter
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::common"

get_all_nodes.each do |server|
    bash "provision-vrouter" do
        user "root"
        code <<-EOH
            contrail-provision-vrouter \
                --conf_file /etc/contrail/contrail-schema.conf \
                --host_name #{server['hostname']} \
                --host_ip #{server['contrail']['floating']['ip']}
        EOH
    end
end

