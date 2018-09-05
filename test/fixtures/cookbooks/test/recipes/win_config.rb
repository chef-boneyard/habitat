include_recipe 'chocolatey'
chocolatey_package 'habitat'
hab_package 'skylerto/splunkforwarder' do
  version '7.0.3/20180418161444'
end

hab_config 'splunkforwarder.default' do
  config(
    directories: {
      path: [
        'C:/hab/pkgs/.../*.log',
      ],
    }
  )
end
