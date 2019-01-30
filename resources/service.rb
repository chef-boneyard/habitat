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
# Run State
property :loaded, [true, false], default: false, desired_state: true
property :running, [true, false], default: false, desired_state: true
# hab svc options which get included based on the action of the resource
property :bind, [String, Array], coerce: proc { |b| b.is_a?(String) ? [b] : b }, default: []
property :binding_mode, [Symbol, String], coerce: proc { |c| c.is_a?(Symbol) ? c.to_s : c }, equal_to: [:strict, 'strict', :relaxed, 'relaxed'], default: :strict
property :bldr_url, String, default: 'https://bldr.alasconnect.com'
property :channel, [Symbol, String], coerce: proc { |c| c.is_a?(Symbol) ? c.to_s : c }, default: 'stable'
property :service_group, String, default: 'default'
property :strategy, String, default: 'none'
property :topology, String, default: 'standalone'
# Connection options
property :remote_sup, String, default: '127.0.0.1:9632', desired_state: false
# Http port needed for querying/comparing current config value
property :remote_sup_http, String, default: '127.0.0.1:9631', desired_state: false

load_current_value do
  svc_status = get_service_details(service_name)
  # Run State
  loaded service_loaded?(svc_status)
  running service_up?(svc_status)
  # Configuration
  bind get_binds(svc_status)
  binding_mode get_binding_mode(svc_status)
  bldr_url get_bldr_url(svc_status)
  channel get_channel(svc_status)
  service_group get_service_group(svc_status)
  strategy get_strategy(svc_status)
  topology get_topology(svc_status)

  Chef::Log.debug("service #{service_name} running state: #{running}")
  Chef::Log.debug("service #{service_name} loaded state: #{loaded}")
  Chef::Log.debug("service #{service_name} binds: #{bind}")
  Chef::Log.debug("service #{service_name} binding_mode: #{binding_mode}")
  Chef::Log.debug("service #{service_name} bldr_url: #{bldr_url}")
  Chef::Log.debug("service #{service_name} channel: #{channel}")
  Chef::Log.debug("service #{service_name} service_group: #{service_group}")
  Chef::Log.debug("service #{service_name} strategy: #{strategy}")
  Chef::Log.debug("service #{service_name} topology: #{topology}")
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
def get_service_details(svc_name)
  http_uri = "http://#{remote_sup_http}"

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

  svcs.find do |s|
    [s['spec_ident']['origin'], s['spec_ident']['name']].join('/') =~ /#{svc_name}/
  end
end

# Run State
def service_loaded?(svc_status)
  if svc_status
    true
  else
    false
  end
end

def service_up?(svc_status)
  svc_status['process']['state'] == 'up'
rescue
  Chef::Log.debug("#{service_name} state not found on the Habitat supervisor")
  false
end

# Configuration
def get_binding_mode(svc_status)
  svc_status['binding_mode']
rescue
  Chef::Log.debug("#{service_name} binding mode not found on the Habitat supervisor")
  # Setting default to strict, as we must match one of the defined values
  'strict'
end

def get_binds(svc_status)
  svc_status['binds']
rescue
  Chef::Log.debug("#{service_name} binds not found on the Habitat supervisor")
  []
end

def get_bldr_url(svc_status)
  svc_status['bldr_url']
rescue
  Chef::Log.debug("#{service_name} bldr url not found on the Habitat supervisor")
  ''
end

def get_channel(svc_status)
  svc_status['channel']
rescue
  Chef::Log.debug("#{service_name} channel not found on the Habitat supervisor")
  ''
end

def get_service_group(svc_status)
  svc_status['service_group'].partition('.').last
rescue
  Chef::Log.debug("#{service_name} service group not found on the Habitat supervisor")
  ''
end

def get_strategy(svc_status)
  svc_status['update_strategy']
rescue
  Chef::Log.debug("#{service_name} strategy not found on the Habitat supervisor")
  ''
end

def get_topology(svc_status)
  svc_status['topology']
rescue
  Chef::Log.debug("#{service_name} topology not found on the Habitat supervisor")
  ''
end

action :load do
  # Set our desired state to loaded
  new_resource.loaded = true

  # Explicitly set configuration properties so default values are reverted to
  new_resource.bind = new_resource.bind
  new_resource.binding_mode = new_resource.binding_mode
  new_resource.bldr_url = new_resource.bldr_url
  new_resource.channel = new_resource.channel
  new_resource.service_group = new_resource.service_group
  new_resource.strategy = new_resource.strategy
  new_resource.topology = new_resource.topology

  converge_if_changed do
    # If load is triggered, and we are already loaded, it means something changed
    if current_resource.loaded
      action_unload
      sleep 1
    end

    execute "hab svc load #{new_resource.service_name} #{svc_options(:load).join(' ')}"
  end
end

action :unload do
  execute "hab svc unload #{new_resource.service_name} #{svc_options(:unload).join(' ')}" if current_resource.loaded
end

action :start do
  unless current_resource.loaded
    Chef::Log.fatal("No service named #{new_resource.service_name} is loaded in the Habitat supervisor")
    raise
  end
  execute "hab svc start #{new_resource.service_name} #{svc_options(:start).join(' ')}" unless current_resource.running
end

action :stop do
  unless current_resource.loaded
    Chef::Log.fatal("No service named #{new_resource.service_name} is loaded in the Habitat supervisor")
    raise
  end
  execute "hab svc stop #{new_resource.service_name} #{svc_options(:stop).join(' ')}" if current_resource.running
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
  def svc_options(current_action)
    opts = []

    # certain options are only valid for specific `hab svc` subcommands.
    case current_action
    when :load
      opts.push(*new_resource.bind.map { |b| "--bind #{b}" }) if new_resource.bind
      opts << "--binding-mode #{new_resource.binding_mode}"
      opts << "--url #{new_resource.bldr_url}" if new_resource.bldr_url
      opts << "--channel #{new_resource.channel}" if new_resource.channel
      opts << "--group #{new_resource.service_group}" if new_resource.service_group
      opts << "--strategy #{new_resource.strategy}" if new_resource.strategy
      opts << "--topology #{new_resource.topology}" if new_resource.topology
    end

    opts << "--remote-sup #{new_resource.remote_sup}" if new_resource.remote_sup

    opts.map(&:split).flatten.compact
  end
end
