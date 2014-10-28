#
# Cookbook Name:: contrail
# Recipe:: cassandra
#
# Copyright 2014, Juniper Networks
#

include_recipe "contrail::default"

apt_repository "cassandra" do
    uri node['contrail']['repos']['cassandra']
    distribution "12x"
    components ["main"]
    key "cassandra.key"
end

package "cassandra" do
    action :upgrade
    notifies :stop, "service[cassandra]", :immediately
    notifies :run, "bash[remove-initial-cassandra-data-dir]", :immediately
end

bash "remove-initial-cassandra-data-dir" do
    action :nothing
    user "root"
    code <<-EOH
        TIMESTAMP=`date +%Y%m%d-%H%M%S`
        mv /var/lib/cassandra /var/lib/cassandra.$TIMESTAMP
        mkdir /var/lib/cassandra
        chown cassandra:cassandra /var/lib/cassandra
    EOH
end

%w{cassandra-env.sh cassandra-rackdc.properties cassandra.yaml}.each do |file|
    template "/etc/cassandra/#{file}" do
        source "#{file}.erb"
        mode 00644
        variables(:servers => get_head_nodes)
        notifies :restart, "service[cassandra]", :delayed
    end
end

service "cassandra" do
    action [:enable, :start]
    restart_command "service cassandra stop && service cassandra start && sleep 5"
end
