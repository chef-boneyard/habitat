name              'habitat'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Habitat related resources for chef-client'
source_url        'https://github.com/chef-cookbooks/habitat'
issues_url        'https://github.com/chef-cookbooks/habitat/issues'
chef_version      '>= 12.20.3'
version           '2.2.3'

%w(ubuntu debian redhat centos suse scientific oracle amazon opensuse opensuseleap windows).each do |os|
  supports os
end

# gem 'toml-rb'
