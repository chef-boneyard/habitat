# habitat CHANGELOG

This file is used to list changes made in each version of the habitat cookbook.

## 0.34.3 (2017-10-06)

- Clarify in the README about action-specific properties

## 0.34.2 (2017-10-06)

- Add `hab_config` resource
- Add `toml` gem to metadata for older versions of Chef that don't have it
- Require Chef 12.20.3 or higher to make use of helper methods and classes in newer versions of Chef

## 0.34.1 (2017-10-04)

- Add `version_compare` method to work with latest Chef

## 0.34.0 (2017-10-03)

- Update `hab_install` to Habitat version 0.34.1

## 0.33.0 (2017-09-25)

**Breaking change**

This version is a compatibility change. All users of this cookbook must upgrade the cookbook to use current versions of Habitat.

- Fix to account for [habitat-sh/habitat#3239](https://github.com/habitat-sh/habitat/pull/3239) - do not provide `/v1/depot` to Depot URL.
- Pin the version of this cookbook along with the version of Habitat we install. This should match minor, but not necessarily patch versions.

## 0.28.0 (2017-09-19)

- Add channel support to sup load/start

## 0.27.0 (2017-09-11)

- Add hab_version and hab_channel to the sup service
- Support multiple binds with hab_service

## 0.26.1 (2017-07-21)

- `hab_package` now properly selects latest version from the specified channel.

## 0.26.0 (2017-07-17)

### Breaking Changes

This cookbook was updated to be compatible with the changes made in Habitat 0.26. With these updates the cookbook now requires Habitat 0.26 or later. The version has been updated to match that of habitat. In the event of future breaking habitat changes the version of this cookbook will be updated to reflect the new minimum habitat release.
  - The cookbook now correctly parses the process status returned by the hab sup services endpoint
  - Packages now pull from the 'stable' channel by default. If you need to pull from another channel there is a new 'channel' property in the package resource that accepts a string.

### Other Changes
  - Resolves deprecation warnings introduced in Chef 13.2
  - Removed references in the readme to Chefstyle and simplified some of the requirements information
  - Added maintainer information to the readme and removed the maintainers file

## v0.4.0 (2017-04-26)

- Backwards incompatible version, requires habitat 0.20 or higher
- Add `hab_sup` resource for managing Habitat supervisor. See readme for usage.
- Rewrite `hab_service` resource to manage services in Habitat supervisor

## v0.3.0 (2017-02-21)

- Add property for ExecStart options. See readme for usage
- Add property for depot_url. See readme for usage
- Added restart action to the resource

## v0.2.0 (2016-11-30)

- Added `version` and `channel` properties to install resource
- Added `depot_url` property to hab_package resource

## v0.1.1 (2016-11-10)

- Removed Chef 11 compatibility in the metadata
- Resolved Chefstyle warnings
- Resolved foodcritic warnings
- Added a chefignore file
- Updated the gitignore file
- Improve the readme format and add badges
- Update all test deps to current
- Remove the apt testing dependency
- Add integration testing in Travis using kitchen-dokken

## v0.1.0 (2016-11-08)

- add `hab_service` resource
- make the `hab_package` resource convergent
- add chefspec and inspec tests
- better documentation through README updates

## v0.0.3 (2016-07-14)

- Initial release, includes `hab_package` and `hab_install` resources
