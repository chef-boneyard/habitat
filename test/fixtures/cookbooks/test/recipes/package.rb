apt_update

hab_install

hab_package 'core/redis'

hab_package 'lamont-granquist/ruby' do
  channel 'unstable'
  version '2.3.1'
end

hab_package 'core/bundler' do
  channel 'unstable'
  version '1.13.3/20161011123917'
end

hab_package 'core/htop' do
  options '--binlink'
end

hab_package 'core/hab-sup' do
  bldr_url 'https://bldr.acceptance.habitat.sh'
  # The Habitat bldr for acceptance isn't monitored and can sometimes
  # be down when we want to run tests in travis. This shouldn't stop
  # us from doing our tests, so ignore failures.
  ignore_failure true
end

hab_package 'binlink' do
  package_name 'core/binlink'
  binlink true
end

hab_package 'binlink_force' do
  package_name 'core/binlink'
  binlink :force
end
