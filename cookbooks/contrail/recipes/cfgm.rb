#
# Cookbook Name:: contrail
# Recipe:: cfgm
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::common"

ruby_block "initialize-contrail-config" do
    block do
        make_config('contrail-api-passwd', secure_password)
        make_config('contrail-schema-passwd', secure_password)
        make_config('contrail-svc-monitor-passwd', secure_password)
        make_config('contrail-control-passwd', secure_password)
        make_config('contrail-metadata-secret', secure_password)
    end
end

%w{ ifmap-server
    contrail-config
    contrail-config-openstack
    contrail-utils
}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

template "/etc/ifmap-server/ifmap.properties" do
    source "ifmap.properties.erb"
    mode 00644
    notifies :restart, "service[ifmap-server]", :delayed
end

template "/etc/ifmap-server/basicauthusers.properties" do
    source "ifmap-basicauthusers.properties.erb"
    mode 00644
    variables(:servers => get_head_nodes)
    notifies :restart, "service[ifmap-server]", :immediately
end

template "/etc/contrail/vnc_api_lib.ini" do
    source "contrail-vnc_api_lib.ini.erb"
    owner "contrail"
    group "contrail"
    # The neutron user must be able to read this
    mode 00644
    notifies :restart, "service[contrail-api]", :delayed
end

%w{ discovery
    svc-monitor
}.each do |pkg|
    template "/etc/contrail/#{pkg}.conf" do
        source "contrail-#{pkg}.conf.erb"
        owner "contrail"
        group "contrail"
        mode 00640
        variables(:servers => get_head_nodes)
        notifies :restart, "service[contrail-#{pkg}]", :immediately
    end
end

%w{ contrail-api
    contrail-schema
}.each do |pkg|
    template "/etc/contrail/#{pkg}.conf" do
        source "#{pkg}.conf.erb"
        owner "contrail"
        group "contrail"
        mode 00640
        variables(:servers => get_head_nodes)
        notifies :restart, "service[#{pkg}]", :immediately
    end
end

%w{ ifmap-server
    contrail-discovery
    contrail-api
    contrail-schema
    contrail-svc-monitor
}.each do |svc|
    service svc do
        action [:enable, :start]
    end
end
