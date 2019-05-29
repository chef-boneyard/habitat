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
hab_package 'core/redis' do
  action :upgrade
end

hab_service 'core/redis' do
  strategy 'rolling'
  topology 'standalone'
  channel :stable
  action [:load, :start]
end

# we need this sleep to let redis stop and for the hab supervisor to
# recognize this and write the state file out otherwise our functional
# tests fail.
ruby_block 'wait-for-redis-stop' do
  block do
    sleep 3
  end
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

# Test Binds

# Single string bind
hab_package 'core/ruby-rails-sample'
hab_service 'core/ruby-rails-sample' do
  bind 'database:postgresql.default'
end

# Test service name matching
hab_package 'core/sensu-backend'
hab_service 'core/sensu-backend'

# Multiple  binds
hab_package 'core/rabbitmq'
hab_service 'core/rabbitmq'

hab_package 'core/sensu'
hab_service 'core/sensu' do
  bind [
    'rabbitmq:rabbitmq.default',
    'redis:redis.default',
  ]
end
