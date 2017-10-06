# Habitat Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/habitat.svg?branch=master)](https://travis-ci.org/chef-cookbooks/habitat) [![Cookbook Version](https://img.shields.io/cookbook/v/habitat.svg)](https://supermarket.chef.io/cookbooks/habitat)

This cookbook provides resources for working with [Habitat](https://habitat.sh). It is intended that these resources will be included in core Chef at some point in the future, so it is important to note:

- APIs are subject to change
- Habitat is a rapidly changing product, and this cookbook may change rapidly as well

(this is a pre-1.0 version, after all)

## Requirements

### Platforms

- RHEL 7+
- Ubuntu 16.04+

### Habitat

- 0.34.1

This cookbook is developed lockstep with the latest release of Habitat to ensure compatibility, going forward from 0.33.0 of the cookbook and 0.33.2 of Habitat itself. When new versions of Habitat are released, the version should be updated in these files:

- `README.md`: note required version in this file
- `resources/install.rb`: set the default to the new version
- `test/integration/install/default_spec.rb`: to match the version from the resource

Additionally, new versions must be tested that all behavior in the cookbook still works, otherwise the cookbook must be updated to match the behavior in the new version of Habitat.

Users who wish to install a specific version of Habitat should use an older (0.28 or earlier) release of this cookbook, but note that is unsupported and they are advised to upgrade ASAP.

### Chef

- Chef 12.11+

### Cookbooks

- None

## Resources

### hab_install

Installs Habitat on the system using the [install script](https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh).

#### Actions

- `install`: Installs Habitat. Does nothing if the `hab` binary is found in the default location for the system (`/bin/hab` on Linux, `/usr/local/bin/hab` on macOS)
- `upgrade`: Installs the latest version of Habitat, does not check if the binary exists

#### Properties

- `install_url`: URL to the install script, default is from the [habitat repo](https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh)
- `bldr_url`: Optional URL to an alternate Builder (defaults to the public Builder)
- `channel`: The release channel to install from (defaults to `stable`)

#### Examples

```ruby
hab_install 'install habitat'
```

```ruby
hab_install 'install habitat' do
  bldr_url "http://localhost"
end
```

### hab_package

Install the specified Habitat package. Requires that Habitat is installed

This resource is written as a library resource because it subclasses Chef's `package` resource/provider to get features such as the multi-package API).

#### actions

- `install`: installs the specified package
- `upgrade`: aliased to install

#### Properties

- `package_name`: A Habitat package name, must include the origin and package name separated by `/`, for example, `core/redis`
- `version`: A Habitat version which contains the version and optionally a release separated by `/`, for example, `3.2.3` or `3.2.3/20160920131015`
- `bldr_url`: The habitat builder url where packages will be downloaded from (defaults to public habitat builder)
- `channel`: The release channel to install from (defaults to `stable`)

While it is valid to pass the version and release with a Habitat package as a "fully qualified package identifier" when using the `hab` CLI, they must be specified using the `version` property when using this resource. See the examples below.

#### Examples

```ruby
hab_package "core/redis"

hab_package "core/redis" do
  version "3.2.3"
  channel "unstable"
end

hab_package "core/redis" do
  version "3.2.3/20160920131015"
end
```

### hab_service

Manages a Habitat application service using `hab sup`/`hab service`. This requires that `core/hab-sup` be running as a service. See the `hab_sup` resource documentation below for more information about how to set that up with this cookbook.

#### Actions

- `load`: (default action) runs `hab service load` to load and start the specified application service
- `unload`: runs `hab service unload` to unload and stop the specified application service
- `start`: runs `hab service start` to start the specified application service
- `stop`: runs `hab service stop` to stop the specified application service

#### Properties

Some properties are only valid for `start` or `load` actions. See the description of each option for indication which action(s) the property is used. This is because the underlying `hab sup` commands have different options available in their context.

- `service_name`: name property, the name of the service, must be in the form of `origin/name`
- `loaded`: state property indicating whether the service is loaded in the supervisor
- `running`: state property indicating whether the service is running in the supervisor
- `permanent_peer`: Only valid for `:start` action, passes `--permanent-peer` to the hab command
- `listen_gossip`: Only valid for `:start` action, passes `--listen-gossip` with the specified address and port, e.g., `0.0.0.0:9638`, to the hab command
- `listen_http`: Only valid for `:start` action, passes `--listen-http` with the specified address and port, e.g., `0.0.0.0:9631`, to the hab command
- `org`: Only valid for `:start` action, passes `--org` with the specified org name to the hab command
- `peer`: Only valid for `:start` action, passes `--peer` with the specified initial peer to the hab command
- `ring`: Only valid for `:start` action, passes `--ring` with the specified ring key name to the hab command
- `strategy`: Only valid for `:start` or `:load` actions, passes `--strategy` with the specified update strategy to the hab command
- `topology`: Only valid for `:start` or `:load` actions, passes `--topology` with the specified service topology to the hab command
- `bldr_url`: Only valid for `:start` or `:load` actions, passes `--url` with the specified Builder URL to the hab command
- `bind`: Only valid for `:start` or `:load` actions, passes `--bind` with the specified services to bind to the hab command
- `service_group`: Only valid for `:start` or `:load` actions, passes `--group` with the specified service group to the hab command
- `config_from`: Only valid for `:start` action, passes `--config-from` with the specified directory to the hab command
- `override_name`: **Advanced Use** Valid for all actions, passes `--override-name` with the specified name to the hab command; used for running services in multiple supervisors
- `channel`: Only valid for `:start` or `:load` actions, passes `--channel` with the specified channel to the hab command

#### Examples

```ruby
# install and load nginx
hab_package "core/nginx"
hab_service "core/nginx"

hab_service "core/nginx unload" do
  service_name "core/nginx"
  action :unload
end

# pass the strategy and topology options to hab service commands (load by default)
hab_service "core/redis" do
  strategy 'rolling'
  topology 'standalone'
end
```

### hab_sup

Runs a Habitat Supervisor for one or more Habitat Services. This requires [Habitat version 0.20 or higher](https://forums.habitat.sh/t/habitat-0-20-0-released/317). It is used in conjunction with `hab_service` which will manage the services loaded and started within the supervisor.

The `run` action handles installing Habitat using the `hab_install` resource, ensures that the `core/hab-sup` package is installed using `hab_package`, and then drops off the appropriate init system definitions and manages the service. At this time, only systemd is supported.

#### Actions

- `run`: starts the `hab-sup` service

#### Properties

- `permanent_peer`: Only valid for `:start` action, passes `--permanent-peer` to the hab command
- `listen_gossip`: Only valid for `:start` action, passes `--listen-gossip` with the specified address and port, e.g., `0.0.0.0:9638`, to the hab command
- `listen_http`: Only valid for `:start` action, passes `--listen-http` with the specified address and port, e.g., `0.0.0.0:9631`, to the hab command
- `org`: Only valid for `:start` action, passes `--org` with the specified org name to the hab command
- `peer`: Only valid for `:start` action, passes `--peer` with the specified initial peer to the hab command
- `ring`: Only valid for `:start` action, passes `--ring` with the specified ring key name to the hab command
- `hab_channel`: The channel to install Habitat from. Defaults to stable
- `override_name`: **Advanced Use** Valid for all actions, passes `--override-name` with the specified name to the hab command; used for running services in multiple supervisors

#### Examples

```ruby
# set up with just the defaults
hab_sup "default"

# run with an override name, requires changing listen_http and
# listen_gossip if a default supervisor is running
hab_sup 'test-options' do
  override_name 'myapps'
  listen_http '0.0.0.0:9999'
  listen_gossip '0.0.0.0:9998'
end
```

### hab_config

Applies a given configuration to a habitat service using `hab config apply`.

#### Actions

- `apply`: (default action) apply the given configuration

#### Properties

- `service_group`: The service group to apply the configuration to, for
  example, `nginx.default`
- `config`: The configuration to apply as a ruby hash, for example,
  `{ worker_count: 2, http: { keepalive_timeout: 120 } }`
- `org`: (optional) passes the `--org` option with the specified org name
  to the hab config command.
- `peer`: (optional) passes the `--peer` option with the specified peer to the
  hab config command.
- `ring`: (optional) passes the `--ring` option with the specified ring key
  name to the hab config command.
- `api_host`: Hostname for the habitat api in order to look up the existing
  configuration. Defaults to `127.0.0.1`.
- `api_port`: Port number for the habitat api. Defaults to `9631`.

#### Notes

The version number of the configuration is automatically generated and will be
the current timestamp in seconds since 1970-01-01 00:00:00 UTC.

#### Examples

```ruby
hab_config "nginx.default" do
  config({
    worker_count: 2,
    http: {
      keepalive_timeout: 120
    }
  })
end
```

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team along with the following maintainers:

- Joshua Timberman [joshua@chef.io](mailto:joshua@chef.io)

The goal of the Community Cookbook Engineering team is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2016-2017, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
