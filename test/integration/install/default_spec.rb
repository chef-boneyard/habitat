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
  its('stdout') { should match(%r{^hab 0.38.0/}) }
  its('exit_status') { should eq 0 }
end
