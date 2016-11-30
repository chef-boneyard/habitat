describe directory("/hab/pkgs/core/redis") do
  it { should exist }
end

describe command("hab pkg path core/redis") do
  its("exit_status") { should eq 0 }
  its("stdout") { should match(%r{/hab/pkgs/core/redis}) }
end

describe directory("/hab/pkgs/lamont-granquist/ruby/2.3.1") do
  it { should exist }
end

describe command("hab pkg path lamont-granquist/ruby/2.3.1") do
  its("exit_status") { should eq 0 }
  its("stdout") { should match(%r{/hab/pkgs/lamont-granquist/ruby/2.3.1}) }
end

describe directory("/hab/pkgs/core/bundler/1.13.3/20161011123917") do
  it { should exist }
end

describe command("hab pkg path core/bundler/1.13.3/20161011123917") do
  its("exit_status") { should eq 0 }
  its("stdout") { should match(%r{/hab/pkgs/core/bundler/1.13.3/20161011123917}) }
end

describe command("hab pkg path core/hab-sup") do
  its("exit_status") { should eq 0 }
  its("stdout") { should match(%r{/hab/pkgs/core/hab-sup}) }
end
