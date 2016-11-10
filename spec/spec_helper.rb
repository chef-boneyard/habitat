require "chefspec"
require "chefspec/berkshelf"

RSpec.configure do |config|
  config.color = true
  config.formatter = "doc"
  config.log_level = :fatal
end
