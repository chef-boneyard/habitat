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
    class HabSupSysvinit < HabSup
      provides :hab_sup_sysvinit
      provides :hab_sup do |node|
        provs = Chef::Platform::ServiceHelpers.service_resource_providers
        node['platform_family'] == 'debian' && !provs.include?(:systemd) && !provs.include?(:upstart)
      end

      action :run do
        super()

        template '/etc/init.d/hab-sup' do
          source "sysvinit/hab-sup-#{node['platform_family']}.erb"
          cookbook 'habitat'
          owner 'root'
          group 'root'
          mode '0755'
          variables(name: 'hab-sup',
                    exec_start_options: exec_start_options,
                    auth_token: new_resource.auth_token)
          action :create
        end

        service 'hab-sup' do
          subscribes :restart, 'template[/etc/init.d/hab-sup]'
          subscribes :restart, 'hab_package[core/hab-sup]'
          subscribes :restart, 'hab_package[core/hab-launcher]'
          action [:enable, :start]
        end
      end

      action :stop do
        service 'hab-sup' do
          action :stop
        end
      end
    end
  end
end
