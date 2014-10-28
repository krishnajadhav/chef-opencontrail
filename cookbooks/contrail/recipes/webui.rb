#
# Cookbook Name:: contrail
# Recipe:: webui
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::common"

%w{ contrail-web-controller
}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

template "/etc/contrail/config.global.js" do
    source "contrail-config.global.js.erb"
    owner "contrail"
    group "contrail"
    mode 00640
    variables(:servers => get_head_nodes)
    notifies :restart, "service[contrail-webui-jobserver]", :immediately
    notifies :restart, "service[contrail-webui-webserver]", :immediately
end

%w{ contrail-webui-jobserver
    contrail-webui-webserver
}.each do |svc|
    service svc do
        action [:enable, :start]
    end
end
