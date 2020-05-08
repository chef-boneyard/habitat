hab_sup 'default' do
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

hab_service 'skylerto/splunkforwarder' do
  gateway_auth_token 'secret'
end

hab_config 'splunkforwarder.default' do
  config(
    directories: {
      path: [
        'C:/hab/pkgs/.../*.log',
      ],
    }
  )
  gateway_auth_token 'secret'
end
