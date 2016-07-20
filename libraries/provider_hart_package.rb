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
require "chef/http/simple"
require "chef/json_compat"

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

        def depo_package(name, version = nil)
          @depo_package ||= {}
          @depo_package[name] ||=
            begin
              name_version = [ name, version ].compact.join("/").squeeze("/").chomp("/").sub(/^\//, "")
              url = "https://willem.habitat.sh/v1/depot/pkgs/#{name_version}"
              url << "/latest" unless name_version.count("/") >= 3
              Chef::JSONCompat.parse(http.get(url))
            rescue Net::HTTPServerException
              nil
            end
        end

        def package_version(name, version = nil)
          i = depo_package(name, version)["ident"]
          "#{i["version"]}/#{i["release"]}"
        end

        def http
          # FIXME: use SimpleJSON when the depot mime-type is fixed
          @http ||= Chef::HTTP::Simple.new("https://willem.habitat.sh/")
        end

        def get_candidate_versions
          package_name_array.zip(new_version_array).map do |n, v|
            package_version(n, v)
          end
        end

        def get_current_versions
          package_name_array.zip(new_version_array).map do |n, v|
            nil
          end
        end

        def install_package(names, versions)
          names.zip(versions).map do |n, v|
            hab("pkg install #{n}/#{v}")
          end
        end

        alias upgrade_package install_package

        def remove_package(name, version)
          names.zip(versions).map do |n, v|
            # FIXME: `hab pkg uninstall` would be a lot safer here
            path = hab("pkg path #{n}/#{v}").stdout
            Chef::Log.warn "semantics of :remove will almost certainly change in the future"
            declare_resource(:directory, path) do
              recursive true
              action :remove
            end
          end
        end

        alias purge_package remove_package

        private

        def hab(*command)
          shell_out_with_timeout!(a_to_s("hab", *command))
        end
      end
    end
  end
end
