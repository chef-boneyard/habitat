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

require 'chef/resource'

class Chef
  class Resource
    class HabSup < Resource
      provides :hab_sup do |_node|
        false
      end

      property :permanent_peer, [true, false], default: false
      property :listen_gossip, String
      property :listen_http, String
      property :override_name, String, default: 'default'
      property :org, String, default: 'default'
      property :peer, String
      property :ring, String
      property :hab_channel, String
      property :auto_update, [true, false], default: false

      action :run do
        hab_install new_resource.name do
          channel new_resource.hab_channel if new_resource.hab_channel
        end

        hab_package 'core/hab-sup'
      end

      action_class do
        def exec_start_options
          opts = []
          opts << '--permanent-peer' if new_resource.permanent_peer
          opts << "--listen-gossip #{new_resource.listen_gossip}" if new_resource.listen_gossip
          opts << "--listen-http #{new_resource.listen_http}" if new_resource.listen_http
          opts << "--override-name #{new_resource.override_name}" unless new_resource.override_name == 'default'
          opts << "--org #{new_resource.org}" unless new_resource.org == 'default'
          opts << "--peer #{new_resource.peer}" if new_resource.peer
          opts << "--ring #{new_resource.ring}" if new_resource.ring
          opts << '--auto-update' if new_resource.auto_update
          opts.join(' ')
        end
      end
    end
  end
end
