#
# Author:: Thom May (<thom@chef.io>)
# Copyright:: Copyright (c) 2016 Chef Software, Inc.
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

require "chef/resource"

class Chef
  class Provider
    class HabInstall < Chef::Provider
      use_inline_resources

      provides :hab_install

      def whyrun_supported?
        true
      end

      def load_current_resource
      end

      action :install do
        do_install unless ::File.exist?(hab_path)
      end

      action :upgrade do
        do_install
      end

      private

      def hab_path
        "/usr/local/bin/hab"
      end

      def do_install
        converge_by "installing hab binary to #{hab_path}" do
          declare_resource(:remote_file, Chef::Config[:file_cache_path] + "/hab-install.sh") do
            source new_resource.install_url
          end
          declare_resource(:execute, "installing with install.sh") do
            command "bash #{Chef::Config[:file_cache_path]}/hab-install.sh"
          end
        end
      end
    end
  end
end
