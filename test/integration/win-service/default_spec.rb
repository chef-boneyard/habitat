describe directory('C:\hab\pkgs\skylerto\splunkforwarder') do
  it { should exist }
end

describe directory('C:\hab\pkgs\ncr_devops_platform\sensu-agent-win') do
  it { should exist }
end

describe file('C:\hab\sup\default\specs\splunkforwarder.spec') do
  it { should_not exist }
end

describe file('C:\hab\sup\default\specs\sensu-agent-win.spec') do
  it { should exist }
  its(:content) { should match(/desired_state = "down"/) }
  its(:content) { should match(/channel = "stable"/) }
  its(:content) { should match(/update_strategy = "rolling"/) }
end
