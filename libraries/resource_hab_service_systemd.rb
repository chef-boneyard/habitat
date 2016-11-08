#
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

require "chef/resource/service"

class Chef
  class Resource
    class HabServiceSystemd < Chef::Resource::Service

      resource_name :hab_service
      provides :hab_service

      property :unit_content, [String, Hash]
      property :environment, String, default: lazy { "SSL_CERT_FILE=#{hab('pkg', 'path', 'core/cacerts').stdout.chomp}/ssl/cert.pem" }

      default_action :start

      private

      def hab(*command)
        shell_out!(clean_array("hab", *command))
      rescue Errno::ENOENT
        Chef::Log.fatal("'hab' binary not found, use the 'hab_install' resource to install it first")
        raise
      end

    end
  end
end
