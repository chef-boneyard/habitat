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
resource_name :hab_service
provides :hab_service

property :service_name, String, name_property: true
property :sup_options, [Array, String]

action :load do
  hab('service', 'load', service_name, sup_options)
end

action :unload do
  hab('service', 'unload', service_name, sup_options)
end

action :start do
  hab('service', 'start', service_name, sup_options)
end

action :stop do
  hab('service', 'stop', service_name, sup_options)
end

action_class do
  def hab(*command)
    shell_out!(clean_array('hab', *command).flatten.compact.join(" "))
  rescue Errno::ENOENT
    Chef::Log.fatal("'hab' binary not found, use the 'hab_install' resource to install it first")
    raise
  end
end
