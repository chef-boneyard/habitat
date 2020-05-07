describe user('hab') do
  it { should exist }
end

describe command('hab -V') do
  its('stdout') { should match(%r{^hab.*/}) }
  its('exit_status') { should eq 0 }
end
