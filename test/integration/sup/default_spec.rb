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

%w(default chef-es).each do |sup|
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
