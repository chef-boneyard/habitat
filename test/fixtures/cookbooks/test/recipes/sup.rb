hab_sup 'tester'

hab_sup 'test-options' do
  override_name 'chef-es'
  listen_http '0.0.0.0:9999'
  listen_gossip '0.0.0.0:9998'
end

ruby_block 'wait-right-here' do
  block do
    sleep 10
  end
end
