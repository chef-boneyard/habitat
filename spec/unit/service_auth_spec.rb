require 'spec_helper'

describe 'test::service_auth' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: '16.04'
    ).converge(described_recipe)
  end

  before(:each) do
    allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return([:systemd])
  end

  context 'when compiling the service recipe for chefspec' do
    it 'loads service' do
      expect(chef_run).to load_hab_service('core/nginx')
    end

    it 'unloads service' do
      expect(chef_run).to unload_hab_service('core/nginx unload')
    end
  end
end
