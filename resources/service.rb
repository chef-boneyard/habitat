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

# hab svc options which get included based on the action of the resource
property :strategy, String
property :topology, String
property :bldr_url, String
property :channel, [Symbol, String]
property :bind, [String, Array], coerce: proc { |b| b.is_a?(String) ? [b] : b }
property :binding_mode, [Symbol, String], equal_to: [:strict, 'strict', :relaxed, 'relaxed'], default: :strict
property :service_group, String
property :remote_sup, String

load_current_value do
  running service_up?(service_name)
  loaded service_loaded?(service_name)

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
def get_service_details(svc_name)
  http_uri = remote_sup ? "http://#{remote_sup}" : 'http://localhost:9631'

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

def service_up?(svc_name)
  sup_for_service_name = get_service_details(svc_name)

  begin
    sup_for_service_name['process']['state'] == 'up'
  rescue
    Chef::Log.debug("#{service_name} not found the Habitat supervisor")
    false
  end
end

def service_loaded?(svc_name)
  sup_for_service_name = get_service_details(svc_name)

  if sup_for_service_name
    true
  else
    false
  end
end

# TODO: Load should detect if options such as bldr_url, channel, binds, etc have changed and reload if they have
action :load do
  execute "hab svc load #{new_resource.service_name} #{svc_options.join(' ')}" unless current_resource.loaded
end

action :unload do
  execute "hab svc unload #{new_resource.service_name} #{svc_options.join(' ')}" if current_resource.loaded
end

action :start do
  # FIXME: Should we do this, which matches the expected Hab workflow, or call action_load?
  unless current_resource.loaded
    Chef::Log.fatal("No service named #{new_resource.service_name} is loaded in the Habitat supervisor")
    raise
  end
  execute "hab svc start #{new_resource.service_name} #{svc_options.join(' ')}" unless current_resource.running
end

action :stop do
  unless current_resource.loaded
    Chef::Log.fatal("No service named #{new_resource.service_name} is loaded in the Habitat supervisor")
    raise
  end
  execute "hab svc stop #{new_resource.service_name} #{svc_options.join(' ')}" if current_resource.running
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
  def svc_options
    opts = []

    # certain options are only valid for specific `hab svc` subcommands.
    case action
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
