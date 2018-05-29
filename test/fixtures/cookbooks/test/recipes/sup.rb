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
