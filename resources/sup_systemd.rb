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
provides :hab_sup do |node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

property :permanent_peer, [true, false], default: false
property :listen_gossip, String
property :listen_http, String
property :override_name, String, default: 'default'
property :org, String, default: 'default'
property :peer, String
property :ring, String

action :run do
  hab_install name
  hab_package 'core/hab-sup'

  systemd_unit "hab-sup-#{override_name}.service" do
    content({
      Unit: {
        Description: "The Habitat Supervisor",
      },
      Service: {
        ExecStart: "/bin/hab sup run #{exec_start_options}",
        Restart: 'on-failure',
      },
      Install: {
        WantedBy: 'default.target',
      },
    })
    action :create
  end

  service "hab-sup-#{override_name}" do
    subscribes :restart, 'systemd_unit[hab-sup.service]'
    action :start
  end
end

action_class do
  def exec_start_options
    opts = []
    opts << "--permanent-peer" if permanent_peer
    opts << "--listen-gossip #{listen_gossip}" if listen_gossip
    opts << "--listen-http #{listen_http}" if listen_http
    opts << "--override-name #{override_name}" unless override_name == 'default'
    opts << "--org #{org}" unless org == 'default'
    opts << "--peer #{peer}" if peer
    opts << "--ring #{ring}" if ring
    opts.join(' ')
  end
end
