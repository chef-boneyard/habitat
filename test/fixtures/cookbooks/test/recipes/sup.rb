hab_sup 'tester' do
  bldr_url 'https://willem.habitat.sh'
end

ruby_block 'wait-for-sup-default-startup' do
  block do
    raise unless File.exist?('/hab/sup/default/data/services.dat')
  end
  retries 30
  retry_delay 1
end

hab_sup 'test-options' do
  override_name 'chef-es'
  listen_http '0.0.0.0:9999'
  listen_gossip '0.0.0.0:9998'
end

ruby_block 'wait-for-sup-chef-es-startup' do
  block do
    raise unless File.exist?('/hab/sup/chef-es/data/services.dat')
  end
  retries 30
  retry_delay 1
end

hab_sup 'single_peer' do
  override_name 'single_peer'
  peer '127.0.0.2'
end

ruby_block 'wait-for-sup-single_peer-startup' do
  block do
    raise unless File.exist?('/hab/sup/single_peer/data/services.dat')
  end
  retries 30
  retry_delay 1
end

hab_sup 'multiple_peers' do
  override_name 'multiple_peers'
  peer ['127.0.0.2', '127.0.0.3']
  listen_http '0.0.0.0:9999'
  listen_gossip '0.0.0.0:9998'
end

ruby_block 'wait-for-sup-multiple_peers-startup' do
  block do
    raise unless File.exist?('/hab/sup/multiple_peers/data/services.dat')
  end
  retries 30
  retry_delay 1
end
