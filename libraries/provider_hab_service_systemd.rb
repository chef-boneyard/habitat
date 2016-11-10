# Copyright:: Copyright 2016, Chef Software, Inc.
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

require "chef/provider/service"

class Chef
  class Provider
    class Service
      class HabServiceSystemd < Chef::Provider::Service

        use_inline_resources

        provides :hab_service_systemd
        provides :hab_service do |node|
          Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
        end

        action :start do
          declare_resource(:systemd_unit, "#{short_service_name}.service") do
            content unit_content
            action :create
          end

          declare_resource(:service, short_service_name) do
            subscribes :restart, "systemd_unit[#{short_service_name}.service]"
            action :start
          end
        end

        action :stop do
          declare_resource(:service, short_service_name) do
            action :stop
          end
        end

        action :enable do
          declare_resource(:systemd_unit, "#{short_service_name}.service") do
            content unit_content
            action :create
          end
        end

        def short_service_name
          new_resource.service_name.split("/")[1]
        end

        def unit_content
          return new_resource.unit_content if new_resource.unit_content
          {
            Unit: {
              Description: short_service_name,
              After: "network.target audit.service",
            },
            Service: {
              Environment: new_resource.environment,
              ExecStart: "/bin/hab start #{new_resource.service_name}",
              Restart: "on-failure",
            },
          }
        end
      end
    end
  end
end
