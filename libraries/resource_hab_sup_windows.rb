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

require 'win32/service' if RUBY_PLATFORM =~ /mswin|mingw32|windows/
require_relative 'resource_hab_sup'

class Chef
  class Resource
    class HabSupWindows < HabSup
      provides :hab_sup_windows
      provides :hab_sup do |node|
        node['platform_family'] == 'windows'
      end

      action :run do
        super()

        # TODO: There has to be a better way to handle auth token on windows
        # than the system wide environment variable
        auth_action = new_resource.auth_token ? :create : :delete
        windows_env 'HAB_AUTH_TOKEN' do
          value new_resource.auth_token if new_resource.auth_token
          action auth_action
        end

        hab_package 'core/windows-service' do
          bldr_url new_resource.bldr_url if new_resource.bldr_url
          version hab_windows_service_version
        end

        execute 'hab pkg exec core/windows-service install' do
          not_if { ::Win32::Service.exists?('Habitat') }
        end

        template 'C:/hab/svc/windows-service/HabService.exe.config' do
          source 'windows/HabService.exe.config.erb'
          cookbook 'habitat'
          variables(exec_start_options: exec_start_options)
          action :create
        end

        service 'Habitat' do
          subscribes :restart, 'windows_env[HAB_AUTH_TOKEN]'
          subscribes :restart, 'template[C:/hab/svc/windows-service/HabService.exe.config]'
          subscribes :restart, 'hab_package[core/hab-sup]'
          subscribes :restart, 'hab_package[core/hab-launcher]'
          action [:enable, :start]
        end
      end
    end
  end
end
