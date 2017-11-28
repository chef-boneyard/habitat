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

      it 'handles installing hab for us' do
        expect(chef_run).to install_hab_install('tester')
      end

      it 'installs hab-sup package' do
        expect(chef_run).to install_hab_package('core/hab-sup')
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
          }
        )
      end

      it 'starts the hab-sup-default service' do
        expect(chef_run).to start_service('hab-sup-default')
          .with(provider: Chef::Provider::Service::Upstart)
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('template[/etc/init/hab-sup-default.conf]')
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
          }
        )
      end

      it 'starts the hab-sup-chef-es service' do
        expect(chef_run).to start_service('hab-sup-chef-es')
          .with(provider: Chef::Provider::Service::Upstart)
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('template[/etc/init/hab-sup-chef-es.conf]')
          .on(:restart).delayed
      end
    end

    context 'a Sysvinit platform' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(
          step_into: ['hab_sup'],
          platform: 'debian',
          version: '7.9'
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
          }
        )
      end

      it 'starts the hab-sup-default service' do
        expect(chef_run).to start_service('hab-sup-default')
        expect(chef_run.service('hab-sup-default'))
          .to subscribe_to('template[/etc/init.d/hab-sup-default]')
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
          }
        )
      end

      it 'starts the hab-sup-chef-es service' do
        expect(chef_run).to start_service('hab-sup-chef-es')
        expect(chef_run.service('hab-sup-chef-es'))
          .to subscribe_to('template[/etc/init.d/hab-sup-chef-es]')
          .on(:restart).delayed
      end
    end
  end
end
