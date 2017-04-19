include_recipe "::install"

package "curl"

user "hab"

hab_package "core/nginx"

hab_service_systemd "core/nginx"

hab_package "core/redis" do
  action :upgrade
  notifies :restart, "hab_service_systemd[core/redis]"
end

hab_service_systemd "core/redis" do
  # Use an array of options!
  exec_start_options ["--listen-gossip 9999", "--listen-http 9998"]
  action :enable
end

hab_package "core/haproxy"

hab_service_systemd "core/haproxy" do
  # Use a string of option [sic]
  exec_start_options "--permanent-peer"
end
