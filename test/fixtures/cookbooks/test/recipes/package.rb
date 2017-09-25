include_recipe '::install'

hab_package 'core/redis'

hab_package 'lamont-granquist/ruby' do
  channel 'unstable'
  version '2.3.1'
end

hab_package 'core/bundler' do
  channel 'unstable'
  version '1.13.3/20161011123917'
end

hab_package 'core/hab-sup' do
  bldr_url 'http://app.acceptance.habitat.sh'
end
