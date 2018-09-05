require 'spec_helper'

describe 'test::sup' do
  context 'when compiling the sup recipe for chefspec' do
    shared_examples_for 'any platform' do
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

      it 'runs hab sup with a auth options' do
        expect(chef_run).to run_hab_sup('test-auth-token')
          .with(
            override_name: 'auth-token',
            listen_http: '0.0.0.0:10001',
            listen_gossip: '0.0.0.0:10000',
            auth_token: 'test'
         )
      end
      
      it 'run hab sup with a single peer' do
        expect(chef_run).to run_hab_sup('single_peer').with(
          override_name: 'single_peer',
          peer: ['127.0.0.2']
        )
      end

      it 'runs hab sup with multiple peers' do
        expect(chef_run).to run_hab_sup('multiple_peers')
          .with(
            override_name: 'multiple_peers',
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

    context 'a Systemd platform' do
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

      it 'starts the hab-sup-default service' do
        expect(chef_run).to start_service('hab-sup-default')
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('systemd_unit[hab-sup-default.service]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
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

      it 'starts the hab-sup-chef-es service' do
        expect(chef_run).to start_service('hab-sup-chef-es')
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('systemd_unit[hab-sup-chef-es.service]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end

      it 'renders a systemd_unit file with auth options' do
        expect(chef_run).to create_systemd_unit('hab-sup-auth-token.service').with(
          content: {
            Unit: {
              Description: 'The Habitat Supervisor',
            },
            Service: {
              Environment: 'HAB_AUTH_TOKEN=test',
              ExecStart: '/bin/hab sup run --listen-gossip 0.0.0.0:10000 --listen-http 0.0.0.0:10001 --override-name auth-token',
              Restart: 'on-failure',
            },
            Install: {
              WantedBy: 'default.target',
            },
          }
        )
      end

      it 'starts the hab-sup-auth-token service' do
        expect(chef_run).to start_service('hab-sup-auth-token')
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('systemd_unit[hab-sup-auth-token.service]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end
    end

    context 'an Upstart platform' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(
          step_into: ['hab_sup'],
          platform: 'ubuntu',
          version: '14.04'
        ).converge(described_recipe)
      end

      before(:each) do
        allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return([:upstart])
      end

      it_behaves_like 'any platform'

      it 'renders a upstart config with default options' do
        expect(chef_run).to create_template('/etc/init/hab-sup-default.conf').with(
          source: 'upstart/hab-sup.conf.erb',
          cookbook: 'habitat',
          owner: 'root',
          group: 'root',
          mode: '0644',
          variables: {
            exec_start_options: '',
            auth_token: nil,
          }
        )
      end

      it 'starts the hab-sup-default service' do
        expect(chef_run).to start_service('hab-sup-default')
          .with(provider: Chef::Provider::Service::Upstart)
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('template[/etc/init/hab-sup-default.conf]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end

      it 'renders a upstart config with custom options' do
        expect(chef_run).to create_template('/etc/init/hab-sup-chef-es.conf').with(
          source: 'upstart/hab-sup.conf.erb',
          cookbook: 'habitat',
          owner: 'root',
          group: 'root',
          mode: '0644',
          variables: {
            exec_start_options: '--listen-gossip 0.0.0.0:9998 --listen-http 0.0.0.0:9999 --override-name chef-es',
            auth_token: nil,
          }
        )
      end

      it 'starts the hab-sup-chef-es service' do
        expect(chef_run).to start_service('hab-sup-chef-es')
          .with(provider: Chef::Provider::Service::Upstart)
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('template[/etc/init/hab-sup-chef-es.conf]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end

      it 'renders a upstart config with auth options' do
        expect(chef_run).to create_template('/etc/init/hab-sup-auth-token.conf').with(
          source: 'upstart/hab-sup.conf.erb',
          cookbook: 'habitat',
          owner: 'root',
          group: 'root',
          mode: '0644',
          variables: {
            exec_start_options: '--listen-gossip 0.0.0.0:10000 --listen-http 0.0.0.0:10001 --override-name auth-token',
            auth_token: 'test',
          }
        )
      end

      it 'starts the hab-sup-auth-token service' do
        expect(chef_run).to start_service('hab-sup-auth-token')
          .with(provider: Chef::Provider::Service::Upstart)
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('template[/etc/init/hab-sup-auth-token.conf]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end
    end

    context 'a Sysvinit platform' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(
          step_into: ['hab_sup'],
          platform: 'debian',
          version: '7.11'
        ).converge(described_recipe)
      end

      before(:each) do
        allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return([])
      end

      it_behaves_like 'any platform'

      it 'renders an init script with default options' do
        expect(chef_run).to create_template('/etc/init.d/hab-sup-default').with(
          source: 'sysvinit/hab-sup-debian.erb',
          cookbook: 'habitat',
          owner: 'root',
          group: 'root',
          mode: '0755',
          variables: {
            name: 'hab-sup-default',
            exec_start_options: '',
            auth_token: nil,
          }
        )
      end

      it 'starts the hab-sup-default service' do
        expect(chef_run).to start_service('hab-sup-default')
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('template[/etc/init.d/hab-sup-default]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end

      it 'renders an init script with custom options' do
        expect(chef_run).to create_template('/etc/init.d/hab-sup-chef-es').with(
          source: 'sysvinit/hab-sup-debian.erb',
          cookbook: 'habitat',
          owner: 'root',
          group: 'root',
          mode: '0755',
          variables: {
            name: 'hab-sup-chef-es',
            exec_start_options: '--listen-gossip 0.0.0.0:9998 --listen-http 0.0.0.0:9999 --override-name chef-es',
            auth_token: nil,
          }
        )
      end

      it 'starts the hab-sup-chef-es service' do
        expect(chef_run).to start_service('hab-sup-chef-es')
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('template[/etc/init.d/hab-sup-chef-es]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end

      it 'renders an init script with auth options' do
        expect(chef_run).to create_template('/etc/init.d/hab-sup-auth-token').with(
          source: 'sysvinit/hab-sup-debian.erb',
          cookbook: 'habitat',
          owner: 'root',
          group: 'root',
          mode: '0755',
          variables: {
            name: 'hab-sup-auth-token',
            exec_start_options: '--listen-gossip 0.0.0.0:10000 --listen-http 0.0.0.0:10001 --override-name auth-token',
            auth_token: 'test',
          }
        )
      end

      it 'starts the hab-sup-auth-token service' do
        expect(chef_run).to start_service('hab-sup-auth-token')
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('template[/etc/init.d/hab-sup-auth-token]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('hab_package[core/hab-sup]')
          .on(:restart).delayed
        expect(chef_run.service('hab-sup-auth-token'))
          .to subscribe_to('hab_package[core/hab-launcher]')
          .on(:restart).delayed
      end
    end
  end
end
