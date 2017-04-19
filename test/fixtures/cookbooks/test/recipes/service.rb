include_recipe "::install"

user "hab"

hab_package "core/nginx"

hab_service "core/nginx"

hab_package "core/redis" do
  action :upgrade
end

hab_service "core/redis" do
  # Use an array of options!
  sup_options ["--strategy rolling", "--topology standalone"]
end

hab_package "core/haproxy"

hab_service "core/haproxy" do
  # Use a string of option [sic]
  sup_options "--topology leader"
end

hab_service "core/redis stop" do
  service_name "core/redis"
  action :stop
end

hab_service "core/haproxy" do
  action :unload
end
