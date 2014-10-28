#
# Cookbook Name:: contrail
# Recipe:: contrail-common
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::default"

apt_repository "contrail" do
    uri node['contrail']['repos']['contrail']
    distribution node['lsb']['codename']
    components ["main"]
    key "contrail.key"
end

template "/usr/local/bin/hup_contrail" do
    source "hup_contrail.erb"
    mode 0755
    owner "root"
    group "root"
    variables(:servers => get_head_nodes)
end
