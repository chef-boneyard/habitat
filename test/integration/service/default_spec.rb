describe user("hab") do
  it { should exist }
end

describe directory("/hab/pkgs/core/nginx") do
  it { should exist }
end

describe file("/etc/systemd/system/nginx.service") do
  it { should exist }
end

describe systemd_service("nginx") do
  it { should be_running }
  it { should be_enabled }
end

describe command("curl http://localhost/") do
  # without this sleep we consistently fail the test O.o
  sleep 3
  its("exit_status") { should eq 0 }
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
