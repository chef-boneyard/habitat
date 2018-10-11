hab_sup 'default'

ruby_block 'wait-for-sup-default-startup' do
  block do
    raise unless File.exist?('C:\hab\sup\default\data\services.dat')
  end
  retries 30
  retry_delay 1
end

hab_user_toml 'splunkforwarder' do
  config(
    directories: {
      path: [
        'C:/hab/pkgs/.../*.log',
      ],
    }
  )
end

hab_package 'skylerto/splunkforwarder'
hab_service 'skylerto/splunkforwarder'
