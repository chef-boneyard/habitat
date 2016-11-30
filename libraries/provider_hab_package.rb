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
require "chef/exceptions"

class Chef
  class Provider
    class Package
      class Hart < Chef::Provider::Package

        use_inline_resources
        use_multipackage_api

        provides :hab_package

        #
        # TODO list for `hab pkg`:
        #
        # kinda sorta analogous to:
        #   apt-cache search
        #   dpkg -l
        #   dpkg -r / dpkg -P (without depsolving?)
        #   apt-get remove/purge (with depsolving?)
        #
        # - hab pkg search ruby
        # - hab pkg info lamont-granquist/ruby
        # - hab pkg info lamont-granquist/ruby/2.3.1
        # - hab pkg info lamont-granquist/ruby/2.3.1/20160101010101
        #   ^^^^^ these will all need client-side caches for the "universe" of the depot
        # - hab pkg uninstall lamont-granquist/ruby
        # - hab pkg uninstall lamont-granquist/ruby/2.3.1
        # - hab pkg uninstall lamont-granquist/ruby/2.3.1/20160101010101
        # - hab pkg list (localinfo?) lamont-granquist/ruby
        # - hab pkg list (localinfo?) lamont-granquist/ruby/2.3.1
        # - hab pkg list (localinfo?) lamont-granquist/ruby/2.3.1/20160101010101
        #   ^^^^^ need a better name
        #

        def load_current_resource
          @current_resource = Chef::Resource::HartPackage.new(new_resource.name)
          current_resource.package_name(strip_version(new_resource.package_name))

          @candidate_version = get_candidate_versions
          current_resource.version(get_current_versions)

          current_resource
        end

        def install_package(names, versions)
          names.zip(versions).map do |n, v|
            hab("pkg", "install", "--url", new_resource.depot_url, "#{strip_version(n)}/#{v}")
          end
        end

        alias_method :upgrade_package, :install_package

        def remove_package(name, version)
          raise "It is too dangerous to :remove packages with the hab_package resource right now. This functionality should be deferred to the hab cli."
          names.zip(versions).map do |n, v| # rubocop:disable UnreachableCode
            # FIXME: `hab pkg uninstall` would be a lot safer here
            path = hab("pkg", "path", "#{n}/#{v}").stdout
            Chef::Log.warn "semantics of :remove will almost certainly change in the future"
            declare_resource(:directory, path) do
              recursive true
              action :remove
            end
          end
        end

        alias_method :purge_package, :remove_package

        private

        def hab(*command)
          shell_out_with_timeout!(clean_array("hab", *command))
        rescue Errno::ENOENT
          Chef::Log.fatal("'hab' binary not found, use the 'hab_install' resource to install it first")
          raise
        end

        def validate_name!(name)
          unless name.squeeze("/").count("/") < 2
            raise ArgumentError, "package name must be specified as 'origin/name', use the 'version' property to specify a version"
          end
        end

        def strip_version(name)
          validate_name!(name)
          n = name.squeeze("/").chomp("/").sub(/^\//, "")
          n = n[0..(n.rindex("/") - 1)] while n.count("/") >= 2
          n
        end

        def depot_package(name, version = nil)
          @depot_package ||= {}
          @depot_package[name] ||=
            begin
              name_version = [ name, version ].compact.join("/").squeeze("/").chomp("/").sub(/^\//, "")
              url = "#{new_resource.depot_url.chomp("/")}/pkgs/#{name_version}"
              url << "/latest" unless name_version.count("/") >= 3
              Chef::JSONCompat.parse(http.get(url))
            rescue Net::HTTPServerException
              nil
            end
        end

        def package_version(name, version = nil)
          p = depot_package(name, version)
          unless p.nil?
            i = p["ident"]
            "#{i["version"]}/#{i["release"]}"
          end
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
            get_installed_version(n)
          end
        end

        def get_installed_version(ident)
          begin
            hab("pkg", "path", ident).stdout.chomp.split("/")[-2..-1].join("/")
          rescue Mixlib::ShellOut::ShellCommandFailed
            nil
          end
        end

        def version_requirement_satisfied?(current_version, new_version)
          return false if new_version.nil? || current_version.nil?

          nv_parts = new_version.squeeze("/").split("/")

          if nv_parts.count < 2
            return current_version.squeeze("/").split("/")[0] == new_version.squeeze("/")
          else
            return current_version.squeeze("/") == new_resource.version.squeeze("/")
          end
        end

      end
    end
  end
end
