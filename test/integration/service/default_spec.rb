describe directory('/hab/pkgs/core/nginx') do
  it { should exist }
end

describe directory('/hab/pkgs/core/redis') do
  it { should exist }
end

describe file('/hab/sup/default/specs/haproxy.spec') do
  it { should_not exist }
end

describe file('/hab/sup/default/specs/redis.spec') do
  it { should exist }
  its(:content) { should match(/desired_state = "down"/) }
  its(:content) { should match(/channel = "stable"/) }
end

describe file('/hab/sup/default/specs/memcached.spec') do
  it { should exist }
  its(:content) { should match(/^desired_state = "up"$/) }
end

describe file('/hab/sup/default/specs/ruby-rails-sample.spec') do
  it { should exist }
end

describe file('/hab/sup/default/specs/sensu.spec') do
  it { should exist }
  its(:content) { should match(/binds = \["rabbitmq:rabbitmq.default", "redis:redis.default"\]/) }
end

describe file('/hab/sup/default/specs/sensu-backend.spec') do
  it { should exist }
  its(:content) { should match(/^desired_state = "up"$/) }
end
