#
# Cookbook Name:: contrail
# Recipe:: neutron
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::mysql"

%w{neutron-server neutron-plugin-contrail}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

bash "neutron-server-setup" do
    guard_interpreter :bash
    environment {
        "SERVICE_TOKEN" => "contrail123",
        "AUTH_PROTOCOL" => "contrail123",
        "QUANTUM_PROTOCOL" => "contrail123",
        "ADMIN_TOKEN" => "contrail123",
        "CONTROLLER" => node['contrail']['openstack']['ip'],
        "AMQP_SERVER" => node['contrail']['openstack']['ip'],
        "QUANTUM" => node['contrail']['cfgm']['ip'],
        "QUANTUM_PORT" => "9696",
        "COMPUTE" => node['contrail']['compute']['ip'],
        "CONTROLLER_MGMT" => node['contrail']['cfgm']['ip'],
    }
    code "/usr/bin/quantum-server-setup.sh"
end

service "neutron-server" do
    action [:enable, :start]
end

template "/etc/neutron/plugins/opencontrail/contrailplugin.ini" do
    source "contrailplugin.ini.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, "service[neutron-server]", :immediately
end
