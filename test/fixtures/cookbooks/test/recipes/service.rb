include_recipe "::install"
hab_sup "default"

user "hab"
group "hab"

hab_package "core/nginx"
hab_service "core/nginx"

# we need to sleep to let the nginx service have enough time to
# startup properly before we can unload it.
ruby_block "wait-for-nginx-startup" do
  block do
    sleep 3
  end
end

hab_service "core/nginx unload" do
  service_name "core/nginx"
  action :unload
end

# redis: options, and then stop
hab_package "core/redis" do
  action :upgrade
end

hab_service "core/redis" do
  strategy 'rolling'
  topology 'standalone'
end

# we need this sleep to let redis stop and for the hab supervisor to
# recognize this and write the state file out otherwise our functional
# tests fail.
ruby_block "wait-for-redis-stop" do
  block do
    sleep 3
  end
end

hab_service "core/redis stop" do
  service_name "core/redis"
  action :stop
end

# memcached
hab_package "core/memcached"
hab_service "core/memcached"
