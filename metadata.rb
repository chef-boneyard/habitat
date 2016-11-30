name "habitat"
maintainer "Chef Software, Inc."
maintainer_email "cookbooks@chef.io"
license "Apache 2.0"
description "Habitat related cookbooks for chef-client"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version "0.2.0"

%w{ubuntu debian redhat centos suse scientific oracle amazon}.each do |os|
  supports os
end

source_url "https://github.com/chef-cookbooks/habitat"
issues_url "https://github.com/chef-cookbooks/habitat/issues"

# we need chef 12.5 for custom resources, and 12.11 for systemd_unit
chef_version ">= 12.11"
