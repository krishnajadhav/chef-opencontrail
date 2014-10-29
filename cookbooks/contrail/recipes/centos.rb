#
# Cookbook Name:: contrail
# Recipe:: centos
#
# Copyright 2014, Juniper Networks
#

template "/etc/yum.repos.d/contrail-install.repo" do
    source "contrail-centos.repo.erb"
    mode 00644
end
