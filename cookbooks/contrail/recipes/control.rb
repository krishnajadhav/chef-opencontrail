#
# Cookbook Name:: contrail
# Recipe:: control
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::common"

ruby_block "initialize-contrail-config" do
    block do
        make_config('contrail-control-passwd', secure_password)
        make_config('contrail-dns-passwd', secure_password)
    end
end

%w{ contrail-openstack-control
    contrail-control
    contrail-dns
    contrail-utils
}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

template "/etc/contrail/dns/dns.conf" do
    source "contrail-dns.conf.erb"
    owner "contrail"
    group "contrail"
    mode 00640
    notifies :restart, "service[contrail-dns]", :immediately
end

template "/etc/contrail/control-node.conf" do
    source "contrail-control-node.conf.erb"
    owner "contrail"
    group "contrail"
    mode 00640
    notifies :restart, "service[contrail-control]", :immediately
end

%w{ contrail-control
    contrail-dns
}.each do |svc|
    service svc do
        action [:enable, :start]
    end
end
