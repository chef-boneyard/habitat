describe command('C:\habitat\hab.exe sup -h') do
  its(:stdout) { should match(/The Habitat Supervisor/) }
end

describe service('Habitat') do
  it { should be_enabled }
  it { should be_running }
end

restart_script = <<-EOH
restart-service habitat
EOH

describe powershell(restart_script) do
  its(:exit_status) { should eq(0) }
end

describe service('Habitat') do
  it { should be_running }
end

describe port('0.0.0.0', 9999) do
  it { should be_listening }
end

describe port('0.0.0.0', 9998) do
  it { should be_listening }
end
