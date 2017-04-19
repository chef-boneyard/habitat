describe user("hab") do
  it { should exist }
end

describe directory("/hab/pkgs/core/nginx") do
  it { should exist }
end

describe directory("/hab/pkgs/core/redis") do
  it { should exist }
end

describe file("/hab/sup/default/specs/haproxy.spec") do
  it { should_not exist }
end

describe file("/hab/sup/default/specs/redis.spec") do
  it { should exist }
  its(:content) { should match(%r{desired_state = "down"}) }
end

describe file("/hab/sup/default/specs/memcached.spec") do
  it { should exist }
  its(:content) { should match(%r{^desired_state = "up"$}) }
end
