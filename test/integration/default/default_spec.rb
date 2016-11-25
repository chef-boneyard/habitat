describe user("hab") do
  it { should exist }
end

describe directory("/hab/pkgs/core/redis") do
  it { should exist }
end

describe file("/etc/systemd/system/redis.service") do
  it { should exist }
end

describe systemd_service("redis") do
  it { should_not be_running }
  it { should be_enabled }
end
