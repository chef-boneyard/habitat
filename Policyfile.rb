# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'habitat'

# Where to find external cookbooks:
default_source :chef_repo, '.'

# Specify a custom source for a single cookbook:
cookbook 'habitat', path: '.'
cookbook 'test', path: './test/fixtures/cookbooks/test'

run_list 'habitat'

named_run_list :sup, 'test::sup'
named_run_list :win_sup, 'test::win_sup'
