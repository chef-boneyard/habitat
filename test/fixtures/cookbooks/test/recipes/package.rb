include_recipe "::install"

hab_package "core/redis"

hab_package "lamont-granquist/ruby" do
  version "2.3.1"
end

hab_package "core/bundler" do
  version "1.13.3/20161011123917"
end

hab_package "core/hab-sup" do
  depot_url "http://app.acceptance.habitat.sh/v1/depot"
end
