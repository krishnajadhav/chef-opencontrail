#
# Cookbook Name:: contrail
# Recipe:: contrail-vrouter
#
# Copyright 2014, Juniper Networks
#

if node['contrail']['manage_nova_compute'] then
    pkgs = %w( contrail-openstack-vrouter )
else 
    if platform?("redhat", "centos", "fedora")
        pkgs = %w( contrail-nodemgr contrail-nova-vif contrail-setup contrail-vrouter contrail-vrouter-init linux-crashdump python-iniparse )
    else
        pkgs = %w( abrt contrail-nodemgr contrail-nova-vif contrail-setup contrail-vrouter contrail-vrouter-init openstack-utils python-thrift )
    end
end

if node['contrail']['haproxy'] then
    pkgs << :haproxy

if platform?("ubuntu")
    File.open("/etc/init/supervisor-vrouter.override", 'a') {|f| f.write("manual") }

pkgs.each do |pkg|
    package pkg do
        action :upgrade
    end
end

bash "enable-vrouter" do
    user "root"
    code <<-EOC
        modprobe vrouter
        sed --in-place '/^vrouter$/d' /etc/modules
        echo 'vrouter' >> /etc/modules
    EOC
    not_if "grep -e '^vrouter$' /etc/modules"
end

template "/etc/network/interfaces.d/iface-vhost0" do
    source "network.vhost.erb"
    owner "root"
    group "root"
    mode 00644
    variables(
        :interface => node['contrail']['compute']['interface'],
        :ip => node['contrail']['compute']['ip'],
        :netmask => node['contrail']['compute']['netmask'],
        :gateway => node['contrail']['compute']['gateway']
    )
end

bash "vhost0-up" do
    user "root"
    code "ifup vhost0"
    not_if "ip link show up | grep vhost0"
end

template "/etc/contrail/contrail-vrouter-agent.conf" do
    source "contrail-vrouter-agent.conf.erb"
    owner "contrail"
    group "contrail"
    mode 00644
    notifies :restart, "service[contrail-vrouter-agent]", :immediately
end

%w{ contrail-vrouter-agent }.each do |pkg|
    service pkg do
        action [:enable, :start]
    end
end
