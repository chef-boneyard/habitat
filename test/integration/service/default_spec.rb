describe directory('/hab/pkgs/core/nginx') do
  it { should exist }
end

describe directory('/hab/pkgs/core/redis') do
  it { should exist }
end

describe file('/hab/sup/default/specs/haproxy.spec') do
  it { should_not exist }
end

describe file('/hab/sup/default/specs/prometheus.spec') do
  it { should exist }
end

describe file('/hab/sup/default/specs/grafana.spec') do
  it { should exist }
  its(:content) { should match(%r{ident = "core/grafana/6.4.3/20191105024430"}) }
  its(:content) { should match(/group = "test"/) }
  its(:content) { should match(%r{bldr_url = "https://bldr-test.habitat.sh"}) }
  its(:content) { should match(/channel = "bldr-1321420393699319808"/) }
  its(:content) { should match(/topology = "standalone"/) }
  its(:content) { should match(/update_strategy = "at-once"/) }
  its(:content) { should match(/binds = \["prom:prometheus.default"\]/) }
  its(:content) { should match(/binding_mode = "relaxed"/) }
  its(:content) { should match(/shutdown_timeout = 10/) }
  its(:content) { should match(/\[health_check_interval\]\nsecs = 32/) }
end

describe directory('/hab/pkgs/core/grafana/6.4.3/20191105024430') do
  it { should exist }
end

describe directory('/hab/pkgs/core/vault/1.1.5') do
  it { should exist }
end

describe file('/hab/sup/default/specs/vault.spec') do
  it { should exist }
  its(:content) { should match(%r{ident = "core/vault/1.1.5"}) }
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

describe file('/hab/sup/default/specs/sensu.spec') do
  it { should exist }
  its(:content) { should match(/binds = \["rabbitmq:rabbitmq.default", "redis:redis.default"\]/) }
end

describe file('/hab/sup/default/specs/sensu-backend.spec') do
  it { should exist }
  its(:content) { should match(/^desired_state = "up"$/) }
end
