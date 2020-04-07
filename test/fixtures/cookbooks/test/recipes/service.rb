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

# Test 1: Load Package (memcached)
hab_package 'core/memcached'
hab_service 'core/memcached'

# Test 2: Load, then Unload Package (nginx)
hab_package 'core/nginx'
hab_service 'core/nginx'

# Wait for load before attempting unload
ruby_block 'wait-for-nginx-load' do
  block do
    raise 'nginx not loaded' unless system 'hab svc status core/nginx'
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/nginx]', :immediately
end
ruby_block 'wait-for-nginx-up' do
  block do
    raise 'nginx not loaded' unless `hab svc status core/nginx`.match(/standalone\s+up\s+up/)
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'ruby_block[wait-for-nginx-load]', :immediately
end

hab_service 'core/nginx unload' do
  service_name 'core/nginx'
  action :unload
end

# Test 3: Load, then stop package (redis)
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
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/redis]', :immediately
end
ruby_block 'wait-for-redis-started' do
  block do
    raise 'redis not started' unless `hab svc status core/redis`.match(/standalone\s+up\s+up/)
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'ruby_block[wait-for-redis-load]', :immediately
end

hab_service 'core/redis stop' do
  service_name 'core/redis'
  action :stop
end

# Test 4: Full Identifier Test (grafana/6.4.3)
hab_package 'core/grafana full identifier' do
  package_name 'core/grafana'
  version '6.4.3/20191105024430'
end
hab_service 'core/grafana full identifier' do
  service_name 'core/grafana/6.4.3/20191105024430'
end

ruby_block 'wait-for-grafana-startup' do
  block do
    raise 'grafana not loaded' unless system 'hab svc status core/grafana'
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/grafana full identifier]', :immediately
end

hab_service 'core/grafana full identifier idempotence' do
  service_name 'core/grafana/6.4.3/20191105024430'
end

# Test 5: Change version (core/vault)
hab_package 'core/vault'
hab_service 'core/vault'

ruby_block 'wait-for-vault-load' do
  block do
    raise 'vault not loaded' unless system 'hab svc status core/vault'
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/vault]', :immediately
end

hab_service 'core/vault version change' do
  service_name 'core/vault/1.1.5'
end

# Test 6: Property Changes
hab_service 'core/grafana property change from defaults' do
  action :load
  service_name 'core/grafana/6.4.3/20191105024430'
  service_group 'test-1'
  bldr_url 'https://bldr-test-1.habitat.sh'
  strategy 'rolling'
  shutdown_timeout 9
  health_check_interval 31
end

hab_service 'core/grafana property change from custom values' do
  action :load
  service_name 'core/grafana/6.4.3/20191105024430'
  service_group 'test'
  bldr_url 'https://bldr-test.habitat.sh'
  channel 'bldr-1321420393699319808'
  topology :standalone
  strategy :'at-once'
  binding_mode :relaxed
  shutdown_timeout 10
  health_check_interval 32
end

# Test 7: Single Bind
hab_package 'core/prometheus'
hab_service 'core/prometheus'

ruby_block 'wait-for-prometheus-startup' do
  block do
    raise 'prometheus not loaded' unless system 'hab svc status core/prometheus'
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/prometheus]', :immediately
end

hab_service 'core/grafana binding' do
  action :load
  service_name 'core/grafana/6.4.3/20191105024430'
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

# Test 8: Test Service Name Matching & Multiple Binds (sensu-backend & sensu + rabbitmq)
hab_package 'core/rabbitmq'
hab_service 'core/rabbitmq'

hab_package 'core/sensu-backend'
hab_service 'core/sensu-backend'

hab_package 'core/sensu'
hab_service 'core/sensu' do
  bind [
    'rabbitmq:rabbitmq.default',
    'redis:redis.default',
  ]
end

# Test 9: Restart the package
hab_package 'core/consul'
hab_service 'core/consul'

ruby_block 'wait-for-consul-load' do
  block do
    raise 'consul not loaded' unless system 'hab svc status core/consul'
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/consul]', :immediately
end
ruby_block 'wait-for-consul-startup' do
  block do
    raise 'consul not started' unless `hab svc status core/consul`.match(/standalone\s+up\s+up/)
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'ruby_block[wait-for-consul-load]', :immediately
end

ruby_block 'wait-for-consul-up-for-30s' do
  block do
    uptime = `hab svc status core/consul`.match(/standalone\s+up\s+up\s+([0-9]+)/)
    raise 'consul not started for 30s' unless uptime.size == 2 && Integer(uptime[1]) > 30
  end
  retries 30
  retry_delay 2
  action :nothing
  subscribes :run, 'ruby_block[wait-for-consul-startup]', :immediately
end

hab_service 'core/consul restart' do
  service_name 'core/consul'
  action :restart
end

ruby_block 'wait-for-consul-restart' do
  block do
    uptime = `hab svc status core/consul`.match(/standalone\s+up\s+up\s+([0-9]+)/)
    raise 'consul not restarted' unless !uptime.nil? && uptime.size == 2 && Integer(uptime[1]) < 30
  end
  retries 60
  retry_delay 1
  action :nothing
  subscribes :run, 'hab_service[core/consul restart]', :immediately
end

# Test 10: Reload the package
ruby_block 'wait-for-consul-up-for-30s' do
  block do
    uptime = `hab svc status core/consul`.match(/standalone\s+up\s+up\s+([0-9]+)/)
    raise 'consul not started for 30s' unless uptime.size == 2 && Integer(uptime[1]) > 30
  end
  retries 30
  retry_delay 1
  action :nothing
  subscribes :run, 'ruby_block[wait-for-consul-startup]', :immediately
end

hab_service 'core/consul reload' do
  service_name 'core/consul'
  action :reload
end

ruby_block 'wait-for-consul-restart' do
  block do
    uptime = `hab svc status core/consul`.match(/standalone\s+up\s+up\s+([0-9]+)/)
    raise 'consul not restarted' unless !uptime.nil? && uptime.size == 2 && Integer(uptime[1]) < 30
  end
  retries 5
  retry_delay 10
  action :nothing
  subscribes :run, 'hab_service[core/consul restart]', :immediately
end
