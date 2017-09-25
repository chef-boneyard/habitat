#
# Copyright:: Copyright (c) 2017 Chef Software, Inc.
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

resource_name :hab_sup

provides :hab_sup_systemd
provides :hab_sup do |_node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

property :permanent_peer, [true, false], default: false
property :listen_gossip, String
property :listen_http, String
property :override_name, String, default: 'default'
property :org, String, default: 'default'
property :peer, String
property :ring, String
property :hab_channel, String

action :run do
  hab_install new_resource.name do
    channel new_resource.hab_channel if new_resource.hab_channel
  end

  hab_package 'core/hab-sup'

  systemd_unit "hab-sup-#{new_resource.override_name}.service" do
    content(Unit: {
              Description: 'The Habitat Supervisor',
            },
            Service: {
              ExecStart: "/bin/hab sup run #{exec_start_options}",
              Restart: 'on-failure',
            },
            Install: {
              WantedBy: 'default.target',
            })
    action :create
  end

  service "hab-sup-#{new_resource.override_name}" do
    subscribes :restart, 'systemd_unit[hab-sup.service]'
    action :start
  end
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
    opts.join(' ')
  end
end
