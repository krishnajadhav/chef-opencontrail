###########################################
#
#  Configuration for this cluster
#
###########################################
default['contrail']['openstack_release'] = "icehouse"
default['contrail']['multi_tenancy'] = false
default['contrail']['manage_neutron'] = false
default['contrail']['manage_nova_compute'] = false
default['contrail']['router_asn'] = 64512
default['contrail']['service_token'] = "contrail123"
default['contrail']['admin_token'] = "contrail123"
default['contrail']['haproxy'] = false
default['contrail']['management']['vip'] = "10.84.13.36"
# Keystone
default['contrail']['keystone_ip'] = "10.84.13.36"
default['contrail']['protocol']['keystone'] = "http"
# Compute
default['contrail']['compute']['interface'] = "eth0"
default['contrail']['compute']['ip'] = "10.84.13.36"
default['contrail']['compute']['netmask'] = "255.255.255.0"
default['contrail']['compute']['gateway'] = "10.84.35.254"
