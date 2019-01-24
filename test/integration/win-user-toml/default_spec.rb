describe file('C:\habitat\hab.exe') do
  it { should exist }
end

splunkforwarder_content = <<-EOF

[directories]
path = ["C:/hab/pkgs/.../*.log"]
EOF

describe file('/hab/user/splunkforwarder/config/user.toml') do
  it { should exist }
  its('content') { should match(splunkforwarder_content.gsub!(/\n/, "\r\n")) }
end
