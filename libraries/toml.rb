require_relative 'dump/toml'

module Toml
  def self.dump(hash)
    Dumper.new(hash).toml_str
  end
end
