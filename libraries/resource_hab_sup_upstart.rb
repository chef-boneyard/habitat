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
    class HabSupUpstart < HabSup
      provides :hab_sup_upstart
      provides :hab_sup do |_node|
        provs = Chef::Platform::ServiceHelpers.service_resource_providers
        !provs.include?(:systemd) && provs.include?(:upstart)
      end

      action :run do
        super()

        template '/etc/init/hab-sup.conf' do
          source 'upstart/hab-sup.conf.erb'
          cookbook 'habitat'
          owner 'root'
          group 'root'
          mode '0644'
          variables(exec_start_options: exec_start_options,
                    auth_token: new_resource.auth_token,
                    gateway_auth_token: new_resource.gateway_auth_token)
          action :create
        end

        service 'hab-sup' do
          # RHEL 6 includes Upstart but Chef won't use it unless we specify the provider.
          provider Chef::Provider::Service::Upstart
          subscribes :restart, 'template[/etc/init/hab-sup.conf]'
          subscribes :restart, 'hab_package[core/hab-sup]'
          subscribes :restart, 'hab_package[core/hab-launcher]'
          action [:enable, :start]
          not_if { node['chef_packages']['chef']['chef_root'].include?('/pkgs/chef/chef-infra-client') }
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
