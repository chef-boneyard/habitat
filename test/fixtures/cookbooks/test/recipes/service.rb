hab_sup 'default' do
  hab_channel 'stable'
  license 'accept'
end

ruby_block 'wait-for-sup-default-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end

hab_package 'core/nginx'
hab_service 'core/nginx'

# we need to sleep to let the nginx service have enough time to
# startup properly before we can unload it.
ruby_block 'wait-for-nginx-startup' do
  block do
    sleep 3
  end
  action :nothing
  subscribes :run, 'hab_service[core/nginx]', :immediately
end

hab_service 'core/nginx unload' do
  service_name 'core/nginx'
  action :unload
end

# redis: options, and then stop
hab_package 'core/redis'
hab_service 'core/redis' do
  strategy :rolling
  topology :standalone
  channel :stable
end

# We need this sleep to let redis start and for the hab supervisor to
# recognize this and write the state file out otherwise our functional
# tests fail.
ruby_block 'wait-for-redis-load' do
  block do
    raise 'redis not loaded' unless system 'hab svc status core/redis'
  end
  retries 5
  retry_delay 1
  action :nothing
  subscribes :run, 'hab_service[core/redis]', :immediately
end

hab_service 'core/redis stop' do
  service_name 'core/redis'
  action :stop
end

# memcached
hab_package 'core/memcached'
hab_service 'core/memcached'

# grafana
hab_package 'core/grafana' do
  version '6.4.3/20191105024430'
end
hab_service 'core/grafana/6.4.3/20191105024430'

ruby_block 'wait-for-grafana-startup' do
  block do
    raise 'grafana not loaded' unless system 'hab svc status core/grafana/6.4.3/20191105024430'
  end
  retries 5
  retry_delay 1
  action :nothing
  subscribes :run, 'hab_service[core/grafana/6.4.3/20191105024430]', :immediately
end

hab_service 'core/grafana/6.4.3/20191105024430 part II' do
  service_name 'core/grafana/6.4.3/20191105024430'
  action :load
end

hab_service 'core/grafana/6.4.3/20191105024430 unload' do
  service_name 'core/grafana/6.4.3/20191105024430'
  action :unload
end

ruby_block 'wait-for-grafana-unload' do
  block do
    raise 'grafana still loaded' if system 'hab svc status core/grafana/6.4.3/20191105024430'
  end
  retries 5
  retry_delay 1
  action :nothing
  subscribes :run, 'hab_service[core/grafana/6.4.3/20191105024430 unload]', :immediately
end

# Grafana, version only
hab_package 'core/grafana' do
  version '4.6.3'
end
hab_service 'core/grafana/4.6.3 part II' do
  action :load
  service_name 'core/grafana/4.6.3'
  service_group 'test-1'
  bldr_url 'https://bldr-test-1.habitat.sh'
  strategy 'rolling'
  shutdown_timeout 9
  health_check_interval 31
end

ruby_block 'wait-for-grafana-startup' do
  block do
    raise 'grafana not loaded' unless system 'hab svc status core/grafana/4.6.3'
  end
  retries 5
  retry_delay 1
  action :nothing
  subscribes :run, 'hab_service[core/grafana/4.6.3]', :immediately
end

# Test Service name matching
hab_package 'core/sensu-backend'
hab_service 'core/sensu-backend'


# Test Binds

# Single string bind + Reload Test
hab_package 'core/prometheus'
hab_service 'core/prometheus'

ruby_block 'wait-for-prometheus-startup' do
  block do
    raise 'prometheus not loaded' unless system 'hab svc status core/prometheus'
  end
  retries 5
  retry_delay 1
  action :nothing
  subscribes :run, 'hab_service[core/prometheus]', :immediately
end

# This should reload the service
hab_service 'core/grafana/4.6.3 part III' do
  action :load
  service_name 'core/grafana/4.6.3'
  service_group 'test'
  bldr_url 'https://bldr-test.habitat.sh'
  channel 'bldr-1321420393699319808'
  topology :standalone
  strategy :'at-once'
  bind 'prom:prometheus.default'
  binding_mode :relaxed
  shutdown_timeout 10
  health_check_interval 32
end

# Multiple binds
hab_package 'core/rabbitmq'
hab_service 'core/rabbitmq'

hab_package 'core/sensu'
hab_service 'core/sensu' do
  bind [
    'rabbitmq:rabbitmq.default',
    'redis:redis.default',
  ]
end
