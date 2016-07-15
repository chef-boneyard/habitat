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

require "chef/provider/package"

class Chef
  class Provider
    class Package
      class Hart < Chef::Provider::Package
        use_multipackage_api

        provides :hart_package

        def load_current_resource
          @current_resource = Chef::Resource::HartPackage.new(new_resource.name)
          current_resource.package_name(new_resource.package_name)

          @candidate_version = get_candidate_versions
          current_resource.version(get_current_versions)

          current_resource
        end

        def install_package(name, version)
          names.zip(versions).map do |n, v|
            hab("pkg install #{name}/#{version}")
          end
        end

        alias_method :upgrade_package, :install_package

        def remove_package(name, version)
          names.zip(versions).map do |n, v|
            # FIXME: `hab pkg uninstall` would be a lot safer here
            path = hab("pkg path #{n}/#{v}").stdout
            FileUtils.rm_rf(path)
          end
        end

        alias_method :purge_package, :remove_package

        private

        def hab(*command)
          shell_out_with_timeout!(a_to_s("hab", *command)
        end
      end
    end
  end
end
