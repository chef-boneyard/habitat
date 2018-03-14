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

resource_name :hab_service

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
property :bldr_url, String
property :bind, [String, Array], coerce: proc { |b| b.is_a?(String) ? [b] : b }
property :service_group, String
property :config_from, String
property :override_name, String, default: 'default'
property :channel, [Symbol, String], equal_to: [:unstable, 'unstable', :current, 'current', :stable, 'stable'], default: :stable

load_current_value do
  running service_up?(service_name)
  loaded ::File.exist?("/hab/sup/#{override_name}/specs/#{service_name.split('/').last}.spec")

  Chef::Log.debug("service #{service_name} running state: #{running}")
  Chef::Log.debug("service #{service_name} loaded state: #{loaded}")
end

# This method is defined here otherwise it isn't usable in the
# `load_current_value` method.
#
# It performs a check with TCPSocket to ensure that the HTTP API is
# available first. If it cannot connect, it assumes that the service
# is not running. It then attempts to reach the `/services` path of
# the API to get a list of services. If this fails for some reason,
# then it assumes the service is not running.
#
# Finally, it walks the services returned by the API to look for the
# service we're configuring. If it is "Up", then we know the service
# is running and fully operational according to Habitat. This is
# wrapped in a begin/rescue block because if the service isn't
# present and `sup_for_service_name` will be nil and we will get a
# NoMethodError.
#
def service_up?(svc_name)
  http_uri = listen_http ? listen_http : 'http://localhost:9631'

  begin
    TCPSocket.new(URI(http_uri).host, URI(http_uri).port).close
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
    Chef::Log.debug("Could not connect to #{http_uri} to retrieve status for #{service_name}")
    return false
  end

  begin
    svcs = Chef::HTTP::SimpleJSON.new(http_uri).get('/services')
  rescue
    Chef::Log.debug("Could not connect to #{http_uri}/services to retrieve status for #{service_name}")
    return false
  end

  sup_for_service_name = svcs.find do |s|
    [s['spec_ident']['origin'], s['spec_ident']['name']].join('/') =~ /#{svc_name}/
  end

  begin
    sup_for_service_name['process']['state'] == 'Up'
  rescue
    Chef::Log.debug("#{service_name} not found the Habitat supervisor")
    false
  end
end

action :load do
  execute "hab sup load #{new_resource.service_name} #{sup_options.join(' ')}" unless current_resource.loaded
end

action :unload do
  execute "hab sup unload #{new_resource.service_name} #{sup_options.join(' ')}" if current_resource.loaded
end

action :start do
  execute "hab sup start #{new_resource.service_name} #{sup_options.join(' ')}" unless current_resource.running
end

action :stop do
  execute "hab sup stop #{new_resource.service_name} #{sup_options.join(' ')}" if current_resource.running
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
      opts.push(*new_resource.bind.map { |b| "--bind #{b}" }) if new_resource.bind
      unless new_resource.bldr_url == 'local'
        opts << "--url #{new_resource.bldr_url}" if new_resource.bldr_url
        opts << "--channel #{new_resource.channel}"
      end
      opts << "--group #{new_resource.service_group}" if new_resource.service_group
      opts << "--strategy #{new_resource.strategy}" if new_resource.strategy
      opts << "--topology #{new_resource.topology}" if new_resource.topology
    when :start
      opts << '--permanent-peer' if new_resource.permanent_peer
      opts.push(*new_resource.bind.map { |b| "--bind #{b}" }) if new_resource.bind
      opts << "--config-from #{new_resource.config_from}" if new_resource.config_from
      unless new_resource.bldr_url == 'local'
        opts << "--url #{new_resource.bldr_url}" if new_resource.bldr_url
        opts << "--channel #{new_resource.channel}"
      end
      opts << "--group #{new_resource.service_group}" if new_resource.service_group
      opts << "--listen-gossip #{new_resource.listen_gossip}" if new_resource.listen_gossip
      opts << "--listen-http #{new_resource.listen_http}" if new_resource.listen_http
      opts << "--org #{new_resource.org}" unless new_resource.org == 'default'
      opts << "--peer #{new_resource.peer}" if new_resource.peer
      opts << "--ring #{new_resource.ring}" if new_resource.ring
      opts << "--strategy #{new_resource.strategy}" if new_resource.strategy
      opts << "--topology #{new_resource.topology}" if new_resource.topology
    end

    opts << "--override-name #{new_resource.override_name}" unless new_resource.override_name == 'default'

    opts.map(&:split).flatten.compact
  end
end
