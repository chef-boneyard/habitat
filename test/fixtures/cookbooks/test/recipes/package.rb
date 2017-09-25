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
<<<<<<< HEAD
  depot_url 'https://app.acceptance.habitat.sh'
=======
  depot_url 'http://app.acceptance.habitat.sh'
>>>>>>> Fix for hab 0.33.2 - do not provide '/v1/depot' to Hab URL
end
