#
# Cookbook Name:: contrail
# Recipe:: analytics
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::common"

%w{ contrail-analytics
}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

%w{ contrail-analytics-api
    contrail-collector
    contrail-query-engine
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

%w{ contrail-analytics-api
    contrail-collector
    contrail-query-engine
}.each do |svc|
    service svc do
        action [:enable, :start]
    end
end
