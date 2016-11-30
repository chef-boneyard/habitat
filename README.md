# Habitat Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/habitat.svg?branch=master)](https://travis-ci.org/chef-cookbooks/habitat) [![Cookbook Version](https://img.shields.io/cookbook/v/habitat.svg)](https://supermarket.chef.io/cookbooks/habitat)

This cookbook provides resources for working with [Habitat](https://habitat.sh). It is intended that these resources will be included in core Chef at some point in the future, so it is important to note:

- APIs are subject to change
- Code style adheres to chef-core (chefstyle)
- Habitat is a rapidly changing product, and this cookbook may change rapidly as well

(this is a pre-1.0 version, after all)

## Requirements

### Platforms
- RHEL 6+
- Ubuntu 12.04+

### Chef

Chef 12.11, for the `systemd_unit` resource.

Resources are written in the style of Chef 12.5 [custom resources](https://docs.chef.io/custom_resources.html) where applicable or available.

### Cookbooks

This cookbook has no external cookbook dependencies. It does not attempt to maintain backwards compatibility with previous Chef versions.

## Resources

### hab_install

Installs Habitat on the system using the [install script](https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh).

This resource is written as a Chef 12.5 custom resource.

#### Actions

* `install`: Installs Habitat. Does nothing if the `hab` binary is found in the default location for the system (`/bin/hab` on Linux, `/usr/local/bin/hab` on macOS)
* `upgrade`: Installs the latest version of Habitat, does not check if the binary exists

#### Properties

* `install_url`: URL to the install script, default is from the [habitat repo](https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh)
* `version`: The version of habitat to install (defaults to latest)
* `channel`: The release channel to install from (defaults to `stable`)

#### Examples

```ruby
hab_install 'install habitat'
```

```ruby
hab_install 'install habitat' do
  version "0.12.0"
end
```

### hab_package

Install the specified Habitat package. Requires that Habitat is installed

This resource is written as a library resource because it subclasses Chef's `package` resource/provider to get features such as the multi-package API).

#### Actions

* `install`: Installs the specified package
* `upgrade`: aliased to install

#### Properties

* `package_name`: A Habitat package name, must include the origin and package name separated by `/`, for example, `core/redis`
* `version`: A Habitat version which contains the version and optionally a release separated by `/`, for example, `3.2.3` or `3.2.3/20160920131015`
* `depot_url`: The habitat depot url where packages will be downloaded from (defaults to public habitat depot)

While it is valid to pass the version and release with a Habitat package as a "fully qualified package identifier" when using the `hab` CLI, they must be specified using the `version` property when using this resource. See the examples below.

#### Examples

```ruby
hab_package "core/redis"

hab_package "core/redis" do
  version "3.2.3"
end

hab_package "core/redis" do
  version "3.2.3/20160920131015"
end
```

### hab_service

Manages a Habitat application service using systemd. It will drop off a unit file using the `systemd_unit` provider in Chef.

This resource is written as a library resource because it subclasses Chef's `service` resource/provider to get built in properties and actions.

This resource requires Chef 12.11 or higher.

A future version of this resource may support other service providers.

#### Actions

* `start`: (default action) writes a `systemd_unit` for the application and starts the service
* `enable`: writes the `systemd_unit` for the application
* `stop`: stops the application service

#### Properties

* `unit_content`: Content passed into the `systemd_unit` resource as its `content` property. By default this is a hash that starts the service with `/bin/hab start`.
* `environment`: An environment string to pass into the unit file. By default this contains the location of the SSL certificate from the Habitat `core/cacerts` package.

#### Examples

```ruby
hab_package 'core/redis'

hab_service 'core/redis' do
  action :enable
end

# unit_content as a hash
hab_service 'myorigin/myapp' do
  unit_content({
    Unit: {
      Description: 'myapp',
      After: 'network.target audit.service'
    },
    Service: {
      Environment: 'HAB_MYAPP=workers=3'
      ExecStart: '/bin/hab start myorigin/myapp'
    }
  })
end

# unit_content as a string
hab_service 'myorigin/myapp' do
  unit_content <<-EOF
[Unit]
Description = myapp
After = network.target audit.service

[Service]
Environment = "HAB_MAPP=workers=3"
ExecStart = "/bin/hab start myorigin/myapp"
Restart = "on-failure"
EOF
end
```

## License and Authors

* Author: Lamont Granquist [lamont@chef.io](mailto:lamont@chef.io)
* Author: Joshua Timberman [joshua@chef.io](mailto:joshua@chef.io)

```text
Copyright 2016, Chef Software, Inc

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
