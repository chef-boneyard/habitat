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

      property :bldr_url, String
      property :permanent_peer, [true, false], default: false
      property :listen_ctl, String
      property :listen_gossip, String
      property :listen_http, String
      property :org, String, default: 'default'
      property :peer, [String, Array], coerce: proc { |b| b.is_a?(String) ? [b] : b }
      property :ring, String
      property :hab_channel, String
      property :auto_update, [true, false], default: false
      property :auth_token, String
      property :gateway_auth_token, String
      property :update_condition, String
      property :limit_no_files, String
      property :license, String, equal_to: ['accept']
      property :health_check_interval, coerce: proc { |h| h.is_a?(String) ? h : h.to_s }
      property :event_stream_application, String
      property :event_stream_environment, String
      property :event_stream_site, String
      property :event_stream_url, String
      property :event_stream_token, String
      property :event_stream_cert, String

      action :run do
        hab_install new_resource.name do
          license new_resource.license
        end

        hab_package 'core/hab-sup' do
          bldr_url new_resource.bldr_url if new_resource.bldr_url
          version hab_version
        end

        hab_package 'core/hab-launcher' do
          bldr_url new_resource.bldr_url if new_resource.bldr_url
          version hab_launcher_version
        end
      end

      action_class do
        include Habitat::Shared

        def exec_start_options
          opts = []
          opts << '--permanent-peer' if new_resource.permanent_peer
          opts << "--listen-ctl #{new_resource.listen_ctl}" if new_resource.listen_ctl
          opts << "--listen-gossip #{new_resource.listen_gossip}" if new_resource.listen_gossip
          opts << "--listen-http #{new_resource.listen_http}" if new_resource.listen_http
          opts << "--org #{new_resource.org}" unless new_resource.org == 'default'
          opts.push(*new_resource.peer.map { |b| "--peer #{b}" }) if new_resource.peer
          opts << "--ring #{new_resource.ring}" if new_resource.ring
          opts << '--auto-update' if new_resource.auto_update
          opts << "--update-condition #{new_resource.update_condition}" if new_resource.update_condition
          opts << "--health-check-interval #{new_resource.health_check_interval}" if new_resource.health_check_interval
          opts << "--event-stream-application #{new_resource.event_stream_application}" if new_resource.event_stream_application
          opts << "--event-stream-environment #{new_resource.event_stream_environment}" if new_resource.event_stream_environment
          opts << "--event-stream-site #{new_resource.event_stream_site}" if new_resource.event_stream_site
          opts << "--event-stream-url #{new_resource.event_stream_url}" if new_resource.event_stream_url
          opts << "--event-stream-token #{new_resource.event_stream_token}" if new_resource.event_stream_token
          opts << "--event-stream-server-certificate #{new_resource.event_stream_cert}" if new_resource.event_stream_cert
          opts.join(' ')
        end
      end
    end
  end
end
