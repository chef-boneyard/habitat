describe user('hab') do
  it { should exist }
end

describe file('/bin/hab') do
  it { should exist }
  it { should be_symlink }
end

# This needs to be updated each time Habitat is released so we ensure we're getting the version
# required by this cookbook.
describe command('hab -V') do
  its('stdout') { should match(%r{^hab 0.83.0/}) }
  its('exit_status') { should eq 0 }
end

describe json('/hab/sup/default/data/census.dat') do
  scpath = ['census_groups', 'nginx.default', 'service_config']
  # Incarnation is just the current timestamp, so we can't compare to an exact
  # value. Instead just make sure it looks right.
  its(scpath + ['incarnation']) { should be > 1_500_000_000 }
  its(scpath + %w(value worker_processes)) { should eq 2 }
  its(scpath + %w(value http keepalive_timeout)) { should eq 120 }
end
