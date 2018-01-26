#
# Copyright:: 2017-2018 Chef Software, Inc.
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

require_relative 'resource_hab_sup'

class Chef
  class Resource
    class HabSupSystemd < HabSup
      provides :hab_sup_systemd
      provides :hab_sup do |_node|
        Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
      end

      action :run do
        super()

        systemd_unit "hab-sup-#{new_resource.override_name}.service" do
          content(Unit: {
                    Description: 'The Habitat Supervisor',
                  },
                  Service: {
                    ExecStart: "/bin/hab sup run #{exec_start_options}",
                    Restart: 'on-failure',
                  },
                  Install: {
                    WantedBy: 'default.target',
                  })
          action :create
        end

        service "hab-sup-#{new_resource.override_name}" do
          subscribes :restart, "systemd_unit[hab-sup-#{new_resource.override_name}.service]"
          action [:enable, :start]
        end
      end
    end
  end
end
