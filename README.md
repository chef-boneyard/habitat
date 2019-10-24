# Habitat Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/habitat.svg?branch=master)](https://travis-ci.org/chef-cookbooks/habitat) [![Cookbook Version](https://img.shields.io/cookbook/v/habitat.svg)](https://supermarket.chef.io/cookbooks/habitat)

This cookbook provides resources for working with [Habitat](https://habitat.sh). It is intended that these resources will be included in core Chef at some point in the future, so it is important to note:

- APIs are subject to change
- Habitat is a rapidly changing product, and this cookbook may change rapidly as well

(this is a pre-1.0 version, after all)

## License Note

Habitat requires acceptance of a license before any habitat commands can be run. To accept the Habitat license using this cookbook, the `license` parameter can be set to `accept` for either the `hab_install` or `hab_sup` resources as shown in the below examples:

```ruby
hab_install 'install habitat' do
  license 'accept'
end
```

```ruby
hab_sup 'default' do
  license 'accept'
end
```

PLEASE NOTE: Without performing one of the above license acceptance steps, all other resources in the habitat cookbook will fail with an error prompting that the license must be accepted.
## Requirements

### Platforms

- RHEL 6+
- Ubuntu 14.04+
- Debian 7+
- Windows 2016

### Habitat

- Habitat version: 0.88.0

This cookbook is developed lockstep with the latest release of Habitat to ensure compatibility, going forward from 0.33.0 of the cookbook and 0.33.2 of Habitat itself. When new versions of Habitat are released, the version should be updated in these files:

- `README.md`: note required version in this file
- `resources/install.rb`: set the default to the new version
- `test/integration/install/default_spec.rb`: to match the version from the resource

Additionally, new versions must be tested that all behavior in the cookbook still works, otherwise the cookbook must be updated to match the behavior in the new version of Habitat.

Users who wish to install a specific version of Habitat should use an older (0.28 or earlier) release of this cookbook, but note that is unsupported and they are advised to upgrade ASAP.

### Chef

- Chef 12.20.3+

### Cookbooks

- None

## Resources

### hab_install

Installs Habitat on the system using the [install script](https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh).

#### Actions

- `install`: Installs Habitat. Does nothing if the `hab` binary is found in the default location for the system (`/bin/hab` on Linux, `/usr/local/bin/hab` on macOS, `C:/habitat/hab.exe` on Windows)
- `upgrade`: Installs the latest version of Habitat, does not check if the binary exists

#### Properties

- `install_url`: URL to the install script, default is from the [habitat repo](https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh)
- `bldr_url`: Optional URL to an alternate Builder (defaults to the public Builder)
- `create_user`: Creates the `hab` system user (defaults to `true`)
- `tmp_dir`: Sets TMPDIR environment variable for location to place temp files.  (required if `/tmp` and `/var/tmp` are mounted `noexec`)
- `license`: Specifies acceptance of habitat license when set to `accept` (defaults to empty string).

#### Examples

Nameless installation

```ruby
hab_install
```

Instalaltion specifying a bldr URL

```ruby
hab_install 'install habitat' do
  bldr_url 'http://localhost'
end
```

### hab_package

Install the specified Habitat package from builder. Requires that Habitat is installed

#### actions

- `install`: installs the specified package
- `upgrade`: installs the specified package. If a newer version is available in the configured channel, upgrades to that version

#### Properties

- `package_name`: A Habitat package name, must include the origin and package name separated by `/`, for example, `core/redis`
- `version`: A Habitat version which contains the version and optionally a release separated by `/`, for example, `3.2.3` or `3.2.3/20160920131015`
- `bldr_url`: The habitat builder url where packages will be downloaded from (defaults to public habitat builder)
- `channel`: The release channel to install from (defaults to `stable`)
- `auth_token`: Auth token for installing a package from a private organization on builder
- `binlink`: If habitat should attempt to binlink the package.  Acceptable values: `true`, `false`, `:force`.  Will faill on binlinking if set to `true` and binary or binlink exists.
- `options`: Pass any additional parameters to the habitat install command.

While it is valid to pass the version and release with a Habitat package as a fully qualified package identifier when using the `hab` CLI, they must be specified using the `version` property when using this resource. See the examples below.

#### Examples

```ruby
hab_package 'core/redis'

hab_package 'core/redis' do
  version '3.2.3'
  channel 'unstable'
end

hab_package 'core/redis' do
  version '3.2.3/20160920131015'
end

hab_package 'core/nginx' do
  binlink :force
end

hab_package 'core/nginx' do
  options '--binlink'
end
```

### hab_service

Manages a Habitat application service using `hab sup`/`hab service`. This requires that `core/hab-sup` be running as a service. See the `hab_sup` resource documentation below for more information about how to set that up with this cookbook.

_Note:_ Applications may run as a specific user. Often with Habitat, the default is `hab`, or `root`. If the application requires another user, then it should be created with Chef's `user` resource.

#### Actions

- `:load`: (default action) runs `hab service load` to load and start the specified application service
- `:unload`: runs `hab service unload` to unload and stop the specified application service
- `:reload`: runs the `:unload` and then `:load` actions
- `:start`: runs `hab service start` to start the specified application service
- `:stop`: runs `hab service stop` to stop the specified application service
- `:restart`: runs the `:stop` and then `:start` actions

#### Properties

The remote_sup property is valid for all actions.

- `remote_sup`: Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
- `remote_sup_http`: Address for remote supervisor http port. Used to pull existing configuration data. If this is invalid, config will be applied on every Chef run.

The follow properties are valid for the `load` action.

- `service_name`: name property, the name of the service, must be in the form of `origin/name`
- `loaded`: state property indicating whether the service is loaded in the supervisor
- `running`: state property indicating whether the service is running in the supervisor
- `strategy`: Passes `--strategy` with the specified update strategy to the hab command
- `topology`: Passes `--topology` with the specified service topology to the hab command
- `bldr_url`: Passes `--url` with the specified Builder URL to the hab command.
- `channel`: Passes `--channel` with the specified channel to the hab command
- `bind`: Passes `--bind` with the specified services to bind to the hab command. If an array of multiple service binds are specified then a `--bind` flag is added for each.
- `binding_mode`: Passes `--binding-mode` with the specified binding mode. Defaults to `:strict`. Options are `:strict` or `:relaxed`
- `service_group`: Passes `--group` with the specified service group to the hab command

#### Examples

```ruby
# install and load nginx
hab_package 'core/nginx'
hab_service 'core/nginx'

hab_service 'core/nginx unload' do
  service_name 'core/nginx'
  action :unload
end

# pass the strategy and topology options to hab service commands (load by default)
hab_service 'core/redis' do
  strategy 'rolling'
  topology 'standalone'
end
```

If the service has it's own user specified that is not the `hab` user, don't create the `hab` user on install, and instead create the application user with Chef's `user` resource

```ruby
hab_install 'install habitat' do
  create_user false
end

user 'acme-apps' do
  system true
end

hab_service 'acme/apps'
```

### hab_sup

Runs a Habitat Supervisor for one or more Habitat Services. It is used in conjunction with `hab_service` which will manage the services loaded and started within the supervisor.

The `run` action handles installing Habitat using the `hab_install` resource, ensures that the appropriate versions of the `core/hab-sup` and `core/hab-launcher` packages are installed using `hab_package`, and then drops off the appropriate init system definitions and manages the service.

#### Actions

- `run`: starts the `hab-sup` service

#### Properties

- `bldr_url`: The Builder URL for the `hab_package` resource, if needed
- `permanent_peer`: Only valid for `:run` action, passes `--permanent-peer` to the hab command
- `listen_ctl`: Only valid for `:run` action, passes `--listen-ctl` with the specified address and port, e.g., `0.0.0.0:9632`, to the hab command
- `listen_gossip`: Only valid for `:run` action, passes `--listen-gossip` with the specified address and port, e.g., `0.0.0.0:9638`, to the hab command
- `listen_http`: Only valid for `:run` action, passes `--listen-http` with the specified address and port, e.g., `0.0.0.0:9631`, to the hab command
- `org`: Only valid for `:run` action, passes `--org` with the specified org name to the hab command
- `peer`: Only valid for `:run` action, passes `--peer` with the specified initial peer to the hab command
- `ring`: Only valid for `:run` action, passes `--ring` with the specified ring key name to the hab command
- `hab_channel`: The channel to install Habitat from. Defaults to stable
- `auth_token`: Auth token for accessing a private organization on bldr. This value is templated into the appropriate service file.
- `license`: Specifies acceptance of habitat license when set to `accept` (defaults to empty string).
- `health_check_interval`: The interval (seconds) on which to run health checks (defaults to 30).

#### Examples

```ruby
# set up with just the defaults
hab_sup 'default'

hab_sup 'test-options' do
  listen_http '0.0.0.0:9999'
  listen_gossip '0.0.0.0:9998'
end
```

```ruby
# Use with an on-prem Builder
# Access to public builder may not be available
hab_sup 'default' do
  bldr_url 'https://bldr.private.net'
end
```

### hab_config

Applies a given configuration to a habitat service using `hab config apply`.

#### Actions

- `apply`: (default action) apply the given configuration

#### Properties

- `service_group`: The service group to apply the configuration to, for example, `nginx.default`
- `config`: The configuration to apply as a ruby hash, for example, `{ worker_count: 2, http: { keepalive_timeout: 120 } }`
- `remote_sup`: Address to a remote Supervisor's Control Gateway [default: 127.0.0.1:9632]
- `remote_sup_http`: Address for remote supervisor http port. Used to pull existing configuration data. If this is invalid, config will be applied on every Chef run.
- `user`: Name of user key to use for encryption. Passes `--user` to `hab config apply`

#### Notes

The version number of the configuration is automatically generated and will be the current timestamp in seconds since 1970-01-01 00:00:00 UTC.

#### Examples

```ruby
hab_config 'nginx.default' do
  config({
    worker_count: 2,
    http: {
      keepalive_timeout: 120
    }
  })
end
```

### hab_user_toml

Templates a user.toml for the specified service. This is written to `/hab/user/<service_name>/config/user.toml`. User.toml can be used to set configuration overriding the default.toml for a given package as an alternative to applying service group level configuration.

#### Actions

- `create`: (default action) Create the user.toml from the specified config.
- `delete`: Delete the user.toml

#### Properties

- `service_name`: The service group to apply the configuration to, for example, `nginx.default`
- `config`: Only valid for `:create` action. The configuration to apply as a ruby hash, for example, `{ worker_count: 2, http: { keepalive_timeout: 120 } }`

#### Examples

```ruby
hab_user_toml 'nginx' do
  config({
    worker_count: 2,
    http: {
      keepalive_timeout: 120
    }
  })
end
```

## Maintainers

This cookbook is maintained by the following maintainers:

- Jon Cowie [jcowie@chef.io](mailto:jcowie@chef.io)

The goal of the Community Cookbook Engineering team is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2016-2018, Chef Software, Inc.

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
