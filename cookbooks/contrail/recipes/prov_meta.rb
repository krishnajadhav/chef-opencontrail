#
# Cookbook Name:: contrail
# Recipe:: prov_meta
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::common"

ruby_block "initialize-contrail-config" do
    block do
        make_config('contrail-metadata-secret', secure_password)
    end
end

bash "provision-linklocal-metadata" do
    user "root"
    code <<-EOH
        contrail-provision-linklocal \
            --conf_file /etc/contrail/contrail-schema.conf \
            --linklocal_service_name metadata \
            --linklocal_service_ip 169.254.169.254 \
            --linklocal_service_port 80 \
            --ipfabric_service_ip 127.0.0.1 \
            --ipfabric_service_port 8775
    EOH
end
