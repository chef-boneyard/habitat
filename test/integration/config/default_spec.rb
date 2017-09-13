describe json('/hab/sup/default/data/census.dat') do
  scpath = ['census_groups', 'nginx.default', 'service_config']
  # Incarnation is just the current timestamp, so we can't compare to an exact
  # value. Instead just make sure it looks right.
  its(scpath + ['incarnation']) { should be > 1_500_000_000 }
  its(scpath + %w(value worker_processes)) { should eq 2 }
  its(scpath + %w(value http keepalive_timeout)) { should eq 120 }
end
