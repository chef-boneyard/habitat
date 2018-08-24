# Copyright:: 2017-2018, Chef Software Inc.
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

resource_name :hab_user_toml

property :config, Mash,
         required: true,
         coerce: proc { |m| m.is_a?(Hash) ? Mash.new(m) : m }
property :service_name, String, name_property: true, desired_state: false

action :create do
  config_directory = "/hab/user/#{new_resource.service_name}/config"

  directory config_directory do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  file "#{config_directory}/user.toml" do
    mode '0600'
    owner 'root'
    group 'root'
    content TOML::Generator.new(new_resource.config).body
    sensitive true
  end
end

action :delete do
  file "/hab/user/#{new_resource.service_name}/config/user.toml" do
    sensitive true
    action :delete
  end
end
