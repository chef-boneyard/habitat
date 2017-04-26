require 'spec_helper'

describe 'test::sup' do
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

  context 'when compiling the sup recipe for chefspec' do
    it 'runs hab sup' do
      expect(chef_run).to run_hab_sup('tester')
    end

    it 'runs hab sup with a custom org' do
      expect(chef_run).to run_hab_sup('test-options')
        .with(
          override_name: 'chef-es',
          listen_http: '0.0.0.0:9999',
          listen_gossip: '0.0.0.0:9998'
        )
    end

    it 'handles installing hab for us' do
      expect(chef_run).to install_hab_install('tester')
    end

    it 'installs hab-sup package' do
      expect(chef_run).to install_hab_package('core/hab-sup')
    end

    it 'renders a systemd_unit file with default options' do
      expect(chef_run).to create_systemd_unit('hab-sup-default.service').with(
        content: {
          Unit: {
            Description: 'The Habitat Supervisor',
          },
          Service: {
            ExecStart: '/bin/hab sup run ',
            Restart: 'on-failure',
          },
          Install: {
            WantedBy: 'default.target',
          },
        }
      )
    end

    it 'renders a systemd_unit file with custom ExecStart' do
      expect(chef_run).to create_systemd_unit('hab-sup-chef-es.service').with(
        content: {
          Unit: {
            Description: 'The Habitat Supervisor',
          },
          Service: {
            ExecStart: '/bin/hab sup run --listen-gossip 0.0.0.0:9998 --listen-http 0.0.0.0:9999 --override-name chef-es',
            Restart: 'on-failure',
          },
          Install: {
            WantedBy: 'default.target',
          },
        }
      )
    end
  end
end
