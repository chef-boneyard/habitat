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

resource_name :hab_service
provides :hab_service

property :service_name, String, name_property: true
property :loaded, [true, false], default: false, desired_state: true
property :running, [true, false], default: false, desired_state: true

# hab sup options which get included based on the action of the resource
property :permanent_peer, [true, false], default: false
property :listen_gossip, String
property :listen_http, String
property :org, String, default: 'default'
property :peer, String
property :ring, String
property :strategy, String
property :topology, String
property :depot_url, String
property :bind, String
property :service_group, String
property :config_from, String
property :override_name, String, default: 'default'

load_current_value do
  require "json"
  require "net/http"
  require "uri"

  http_uri = if listen_http
               URI(listen_http)
             else
               URI('http://localhost:9631')
             end

  services_uri = URI.join(http_uri, "services")
  svcs = JSON.parse(Net::HTTP.get(services_uri))

  sup_for_service_name = svcs.find do |s|
    [s["spec_ident"]["origin"], s["spec_ident"]["name"]].join('/') =~ %r{#{service_name}}
  end

  running begin
            sup_for_service_name["supervisor"]["state"] == "Up"
          rescue
            false
          end
  loaded ::File.exist?("/hab/sup/#{override_name}/specs/#{service_name.split('/').last}.spec")

  Chef::Log.debug("service #{service_name} running state: #{running}")
  Chef::Log.debug("service #{service_name} loaded state: #{loaded}")
end

action :load do
  unless loaded
    execute "hab sup load #{service_name} #{sup_options.join(' ')}"
  end
end

action :unload do
  if loaded
    execute "hab sup unload #{service_name} #{sup_options.join}"
  end
end

action :start do
  unless running
    execute "hab sup start #{service_name} #{sup_options.join}"
  end
end

action :stop do
  if running
    execute "hab sup stop #{service_name} #{sup_options.join}"
  end
end

action :restart do
  action_stop
  sleep 1
  action_start
end

action :reload do
  action_unload
  sleep 1
  action_load
end

action_class do
  def sup_options
    opts = []

    # certain options are only valid for specific `hab sup` subcommands.
    case action
    when :load
      opts << "--bind #{bind}" if bind
      opts << "--url #{depot_url}" if depot_url
      opts << "--group #{service_group}" if service_group
      opts << "--strategy #{strategy}" if strategy
      opts << "--topology #{topology}" if topology
    when :start
      opts << "--permanent-peer" if permanent_peer
      opts << "--bind #{bind}" if bind
      opts << "--config-from #{config_from}" if config_from
      opts << "--url #{depot_url}" if depot_url
      opts << "--group #{service_group}" if service_group
      opts << "--listen-gossip #{listen_gossip}" if listen_gossip
      opts << "--listen-http #{listen_http}" if listen_http
      opts << "--org #{org}" unless org == 'default'
      opts << "--peer #{peer}" if peer
      opts << "--ring #{ring}" if ring
      opts << "--strategy #{strategy}" if strategy
      opts << "--topology #{topology}" if topology
    end

    opts << "--override-name #{override_name}" unless override_name == 'default'

    # we need to pass the options to the `hab` method, and if we don't
    # split them, we'll end up with an invalid argument because it
    # will be something like this:
    #
    # hab sup load core/redis '--strategy rolling'
    #
    # instead of this:
    #
    # hab sup load core/redis --strategy rolling
    #
    opts.map {|o| o.split}.flatten.compact
  end

  def service_loaded?

  end

  def service_running?

  end

  def hab(*command)
    shell_out!(clean_array('hab', *command))
  rescue Errno::ENOENT
    Chef::Log.fatal("'hab' binary not found, use the 'hab_install' resource to install it first")
    raise
  end
end
