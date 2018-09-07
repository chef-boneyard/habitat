require 'spec_helper'

describe 'test::service' do
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

    it 'stops service' do
      expect(chef_run).to stop_hab_service('core/redis stop')
    end

    it 'unloads service' do
      expect(chef_run).to unload_hab_service('core/nginx unload')
    end

    it 'loads a service with options' do
      expect(chef_run).to load_hab_service('core/redis').with(
        strategy: 'rolling',
        topology: 'standalone',
        channel: :stable
      )
    end

    it 'loads a service with a single bind' do
      expect(chef_run).to load_hab_service('core/ruby-rails-sample').with(
        bind: [
          'database:postgresql.default',
        ]
      )
    end

    it 'loads a service with multiple binds' do
      expect(chef_run).to load_hab_service('core/sensu').with(
        bind: [
          'rabbitmq:rabbitmq.default',
          'redis:redis.default',
        ]
      )
    end
  end
end
