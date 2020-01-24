hab_sup 'default' do
  hab_channel 'stable'
  license 'accept'
  gateway_auth_token 'secret'
end

ruby_block 'wait-for-sup-default-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end

hab_package 'core/nginx'
hab_service 'core/nginx' do
  gateway_auth_token 'secret'
end

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
  gateway_auth_token 'secret'
  action :unload
end
