describe file("/bin/hab") do
  it { should exist }
  it { should be_symlink }
end

describe command("hab -V") do
  its("stdout") { should match(/^hab 0.12.0/) }
  its("exit_status") { should eq 0 }
end
