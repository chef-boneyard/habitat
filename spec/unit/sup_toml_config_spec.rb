require 'spec_helper'

describe 'test::sup_toml_config' do
  shared_examples_for 'any platform' do
    it 'runs hab sup' do
      expect(chef_run).to run_hab_sup('tester')
    end

    it 'runs hab sup with a custom org' do
      expect(chef_run).to run_hab_sup('test-options')
        .with(
          listen_http: '0.0.0.0:9999',
          listen_gossip: '0.0.0.0:9998'
        )
    end

    it 'runs hab sup with a auth options' do
      expect(chef_run).to run_hab_sup('test-auth-token')
        .with(
          listen_http: '0.0.0.0:10001',
          listen_gossip: '0.0.0.0:10000',
          auth_token: 'test'
        )
    end

    it 'runs hab sup with a gateway auth token' do
      expect(chef_run).to run_hab_sup('test-gateway-auth-token')
        .with(
          listen_http: '0.0.0.0:10001',
          listen_gossip: '0.0.0.0:10000',
          gateway_auth_token: 'secret'
        )
    end

    it 'run hab sup with a single peer' do
      expect(chef_run).to run_hab_sup('single_peer').with(
        peer: ['127.0.0.2']
      )
    end

    it 'runs hab sup with multiple peers' do
      expect(chef_run).to run_hab_sup('multiple_peers')
        .with(
          peer: ['127.0.0.2', '127.0.0.3']
        )
    end

    it 'handles installing hab for us' do
      expect(chef_run).to install_hab_install('tester')
    end

    it 'installs hab-sup package' do
      expect(chef_run).to install_hab_package('core/hab-sup')
    end

    it 'installs hab-launcher package' do
      expect(chef_run).to install_hab_package('core/hab-launcher')
    end
  end
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

    it_behaves_like 'any platform'
    it 'Creates Supervisor toml configuration file' do
      expect(chef_run).to create_directory('/hab/sup/default/config')
      expect(chef_run).to create_template('/hab/sup/default/config/sup.toml')
    end
  end
end
