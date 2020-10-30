require 'spec_helper'

describe 'test::sup_toml_config' do
  context 'When toml_config flag is set to true for hab_sup' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(
        step_into: ['hab_sup'],
        platform: 'ubuntu',
        version: '16.04'
      ).converge(described_recipe)
    end

    before(:each) do
      allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return([:systemd])
    end

    it 'Creates Supervisor toml configuration file' do
      expect(chef_run).to create_directory('/hab/sup/default/config')
      expect(chef_run).to create_template('/hab/sup/default/config/sup.toml')
    end
  end
end
