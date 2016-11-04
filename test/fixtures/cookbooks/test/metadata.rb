maintainer "Lamont Granquist"
maintainer_email "lamont@scriptkiddie.org"
license "Apache 2.0"
source_url "https://github.com/chef-cookbooks/habitat"
issues_url "https://github.com/chef-cookbooks/habitat/issues"
description "test"
long_description "test"
version "0.0.1"
name "test"

depends "habitat"

chef_version ">= 12.0.3" if respond_to?(:chef_version)
