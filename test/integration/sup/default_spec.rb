describe command('/bin/hab sup -h') do
  its(:stdout) { should match(/The Habitat Supervisor/) }
end

svc_manager = if command('systemctl --help').exit_status == 0
                'systemd'
              elsif command('initctl --help').exit_status == 0
                'upstart'
              else
                'sysv'
              end

%w(default chef-es auth-token).each do |sup|
  describe file("/hab/sup/#{sup}/data/services.dat") do
    it { should exist }
    its(:content) { should match('[]') }
  end

  describe send("#{svc_manager}_service", "hab-sup-#{sup}") do
    it { should be_running }
  end

  cmd = case svc_manager
        when 'systemd'
          "systemctl restart hab-sup-#{sup}"
        when 'upstart'
          "initctl restart hab-sup-#{sup}"
        when 'sysv'
          "/etc/init.d/hab-sup-#{sup} restart"
        end

  describe command(cmd) do
    its(:exit_status) { should eq(0) }
  end

  describe send("#{svc_manager}_service", "hab-sup-#{sup}") do
    it { should be_running }
  end
end

# Validate HAB_AUTH_TOKEN
case svc_manager
when 'systemd'
  describe file('/etc/systemd/system/hab-sup-default.service') do
    its('content') { should_not match('Environment = HAB_AUTH_TOKEN=test') }
  end

  describe file('/etc/systemd/system/hab-sup-auth-token.service') do
    its('content') { should match('Environment = HAB_AUTH_TOKEN=test') }
  end
when 'upstart'
  describe file('/etc/init/hab-sup-default.conf') do
    its('content') { should_not match('env HAB_AUTH_TOKEN=test') }
  end

  describe file('/etc/init/hab-sup-auth-token.conf') do
    its('content') { should match('env HAB_AUTH_TOKEN=test') }
  end
when 'sysv'
  describe file('/etc/init.d/hab-sup-default') do
    its('content') { should_not match('export HAB_AUTH_TOKEN=test') }
  end

  describe file('/etc/init.d/hab-sup-auth-token') do
    its('content') { should match('export HAB_AUTH_TOKEN=test') }
  end
end
