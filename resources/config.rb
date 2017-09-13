# Copyright:: Copyright (c) 2017 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'toml'
require 'net/http'
require 'json'

resource_name :hab_config

property :config, Mash,
         required: true,
         coerce: proc { |m| m.is_a?(Hash) ? Mash.new(m) : m }
property :service_group, String, name_property: true, desired_state: false
property :peer, String, desired_state: false
property :org, String, desired_state: false
property :ring, String, desired_state: false
property :api_host, String, default: '127.0.0.1', desired_state: false
property :api_port, Integer, default: 9631, desired_state: false

load_current_value do
  uri = URI("http://#{api_host}:#{api_port}/census")
  begin
    census = Mash.new(JSON.parse(Net::HTTP.get(uri)))
    sc = census['census_groups'][service_group]['service_config']['value']
  rescue
    # Default to a blank config if anything (http error, json parsing, finding
    # the config object) goes wrong
    sc = {}
  end
  config sc
end

action :apply do
  converge_if_changed do
    # Use the current timestamp as the serial number/incarnation
    incarnation = Time.now.tv_sec

    opts = []
    # opts gets flattened by shell_out_compact later
    opts << ['--peer', new_resource.peer] if new_resource.peer
    opts << ['--org', new_resource.org] if new_resource.org
    opts << ['--ring', new_resource.ring] if new_resource.ring

    tempfile = Tempfile.new(['hab_config', '.toml'])
    begin
      tempfile.write(TOML::Generator.new(new_resource.config).body)
      tempfile.close
      shell_out_compact!(['hab', 'config', 'apply', opts,
                          new_resource.service_group, incarnation,
                          tempfile.path])
    ensure
      tempfile.close
      tempfile.unlink
    end
  end
end
