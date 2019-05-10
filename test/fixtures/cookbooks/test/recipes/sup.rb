directory '/hab/sup' do
  recursive true
  action :nothing
  retries 30
  retry_delay 1
end

hab_sup 'tester' do
  bldr_url 'https://willem.habitat.sh'
  license 'accept'
end

ruby_block 'wait-for-sup-default-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end

hab_sup 'test-options' do
  license 'accept'
  listen_http '0.0.0.0:9999'
  listen_gossip '0.0.0.0:9998'
  notifies :stop, 'hab_sup[tester]', :before
  notifies :delete, 'directory[/hab/sup]', :before
end

ruby_block 'wait-for-sup-chef-es-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end

hab_sup 'test-auth-token' do
  license 'accept'
  auth_token 'test'
  listen_http '0.0.0.0:10001'
  listen_gossip '0.0.0.0:10000'
  notifies :stop, 'hab_sup[test-options]', :before
  notifies :delete, 'directory[/hab/sup]', :before
end

ruby_block 'wait-for-sup-test-auth-token-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end

hab_sup 'single_peer' do
  license 'accept'
  listen_http '0.0.0.0:8999'
  listen_gossip '0.0.0.0:8998'
  peer '127.0.0.2'
  notifies :stop, 'hab_sup[test-auth-token]', :before
  notifies :delete, 'directory[/hab/sup]', :before
end

ruby_block 'wait-for-sup-single_peer-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end

hab_sup 'multiple_peers' do
  license 'accept'
  peer ['127.0.0.2', '127.0.0.3']
  listen_http '0.0.0.0:7999'
  listen_gossip '0.0.0.0:7998'
  notifies :stop, 'hab_sup[single_peer]', :before
  notifies :delete, 'directory[/hab/sup]', :before
end

ruby_block 'wait-for-sup-multiple_peers-startup' do
  block do
    raise unless system('hab sup status')
  end
  retries 30
  retry_delay 1
end
