# Habitat Cookbook CHANGELOG

This file is used to list changes made in each version of the habitat cookbook.

## Unreleased ## Unreleased

- resolved cookstyle error: resources/config.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`
- resolved cookstyle error: resources/install.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`
- resolved cookstyle error: resources/service.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`
- resolved cookstyle error: resources/user_toml.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`

## Unreleased

<!-- latest_release unreleased -->
## Unreleased

#### Merged Pull Requests
- pipeline testing updates [#259](https://github.com/chef-cookbooks/habitat/pull/259) ([collinmcneese](https://github.com/collinmcneese))
- Cookstyle Bot Auto Corrections with Cookstyle 7.5.2 [#257](https://github.com/chef-cookbooks/habitat/pull/257) ([cookstyle[bot]](https://github.com/cookstyle[bot]))
<!-- latest_release -->

## [2.2.4](https://github.com/chef-cookbooks/habitat/tree/2.2.4) (2020-11-19)

#### Merged Pull Requests
- Changelog [#255](https://github.com/chef-cookbooks/habitat/pull/255) ([sam1el](https://github.com/sam1el))



## 2.2.4 (2020-11-19)

#### Merged Pull Requests

- Adds support for Supervisor toml config [#254](https://github.com/chef-cookbooks/habitat/pull/254) ([collinmcneese](https://github.com/collinmcneese))
- Cookstyle Bot Auto Corrections with Cookstyle 6.18.8 [#253](https://github.com/chef-cookbooks/habitat/pull/253) ([cookstyle[bot]](https://github.com/cookstyle[bot]))
- Automated PR: Standardising Files [#252](https://github.com/chef-cookbooks/habitat/pull/252) ([xorimabot](https://github.com/xorimabot))
- Fixed hab_service flapping on bldr_url and update_condition [#251](https://github.com/chef-cookbooks/habitat/pull/251) ([mattray](https://github.com/mattray))
- It&#39;s `event_stream_cert` in the code [#249](https://github.com/chef-cookbooks/habitat/pull/249) ([mattray](https://github.com/mattray))
- Automated PR: Standardising Files [#248](https://github.com/chef-cookbooks/habitat/pull/248) ([xorimabot](https://github.com/xorimabot))

## 2.2.3 (2020-06-25)

#### Merged Pull Requests

- correcting some documentation and fixing tagging [#247](https://github.com/chef-cookbooks/habitat/pull/247) ([sam1el](https://github.com/sam1el))

## 2.2.2 (2020-06-18)

#### Merged Pull Requests

- updates custom resources to add resource_name [#246](https://github.com/chef-cookbooks/habitat/pull/246) ([collinmcneese](https://github.com/collinmcneese))
- Automated PR: Standardising Files [#244](https://github.com/chef-cookbooks/habitat/pull/244) ([xorimabot](https://github.com/xorimabot))
- Automated PR: Cookstyle Changes [#243](https://github.com/chef-cookbooks/habitat/pull/243) ([xorimabot](https://github.com/xorimabot))

## 2.2.1 (2020-05-28)

- With the new availabilty of an embedded Builder server with A2 we wanted to add the option of using it with this cookbook. As this changes the URL to the api, we needed to alter the resources that use it.
- Had idempotance issues with the install resource. Those are now corrected

#### Merged Pull Requests

- Automated PR: Standardising Files [#242](https://github.com/chef-cookbooks/habitat/pull/242) ([xorimabot](https://github.com/xorimabot))
- updating how we handle the bldr_url to accommodate on-prem installed with Automate [#241](https://github.com/chef-cookbooks/habitat/pull/241) ([danielcbright](https://github.com/danielcbright))
- fixes hab_install guard for resource_hab_sup [#239](https://github.com/chef-cookbooks/habitat/pull/239) ([collinmcneese](https://github.com/collinmcneese))
- correcting all syntax issue [#238](https://github.com/chef-cookbooks/habitat/pull/238) ([sam1el](https://github.com/sam1el))
- Automated PR: Cookstyle Changes [#237](https://github.com/chef-cookbooks/habitat/pull/237) ([xorimabot](https://github.com/xorimabot))

## 2.1.0 (2020-05-07)

- Integrated Toml functions as a helper library to remove external gem dependencies. This will also make airgap usage easier

#### Merged Pull Requests

- Feature/toml [#236](https://github.com/chef-cookbooks/habitat/pull/236) ([sam1el](https://github.com/sam1el))
- adding effortless compatibility [#235](https://github.com/chef-cookbooks/habitat/pull/235) ([sam1el](https://github.com/sam1el))

## 2.0.5 (2020-04-30)

- There was an issue where the windows service was not correctly setting the launcher version in the service condig. This cause a broken install and/or update when unpinning your version. We have corrected this issue and all version changes are now populating as expected.

#### Merged Pull Requests

- Fix for windows-launcher config (#234)

## 2.0.4 (2020-04-29)

- Correcting merge conflict issues which broke the cookbook at compile time

## 2.0.3 (2020-04-28)

- correcting windows launcher path issue which caused the windows service to no longer start.

#### Merged Pull Requests

- correcting launcher path issue (#13) - [@sam1el](https://github.com/sam1el)

## 2.0.2 (2020-04-08)

- Able to unintall packages using the `hab_package` resource. This includes the `--no-deps` and the `--keep-latest`. Keep latest is only available on habitat 1.5.86+
- Able to select the version of habitat installed as wells as, supervisor, launcher and, windows-servcie
- All current `--event-stream` functions are now available to habitat versions 1.5.86 and up for the `hab_sup` resource
- `windows-service` Can now be configured properly with `--event-stream` as well has your `HAB_AUTH_TOKEN` `HAB_BLDR_URL` and, `HAB_AUTH_GATEWAY_TOKEN`

**\*See README.MD for usage of all new functions**

#### Merged Pull Requests

- Automated PR: Standardising Files [#229](https://github.com/chef-cookbooks/habitat/pull/229) ([xorimabot](https://github.com/xorimabot))
- Overhaul to testing and cookbook resources [#228](https://github.com/chef-cookbooks/habitat/pull/228)
- Automated PR: Standardising Files [#226](https://github.com/chef-cookbooks/habitat/pull/226) ([xorimabot](https://github.com/xorimabot))
- Automated PR: Cookstyle Changes [#225](https://github.com/chef-cookbooks/habitat/pull/225) ([xorimabot](https://github.com/xorimabot))
- resolved cookstyle error: libraries/provider_hab_package.rb:174:13 convention: `Style/RedundantReturn`
- resolved cookstyle error: libraries/provider_hab_package.rb:176:13 convention: `Style/RedundantReturn`

## 1.7.0 (2020-04-08)

- adds windows Github Actions testing for issue #193 [#224](https://github.com/chef-cookbooks/habitat/pull/224) ([collinmcneese](https://github.com/collinmcneese))
- changing the windows service cofig to better reflect newer functional… [#223](https://github.com/chef-cookbooks/habitat/pull/223) ([sam1el](https://github.com/sam1el))
- removing update-confition defaults and tests [#221](https://github.com/chef-cookbooks/habitat/pull/221) ([sam1el](https://github.com/sam1el))
- Added optional settings for Windows service to recongize local or provided envoringment variables including
  - HAB_AUTH_TOKEN
  - HAB_GATEWAY_AUTH_TOKEN
  - HAB_BLDR_URL

## 1.6.2 (2020-04-07)

#### Merged Pull Requests

- changing the windows service cofig to better reflect newer functional… [#223](https://github.com/chef-cookbooks/habitat/pull/223) ([sam1el](https://github.com/sam1el))
- removing update-confition defaults and tests [#221](https://github.com/chef-cookbooks/habitat/pull/221) ([sam1el](https://github.com/sam1el))

## 1.6.0 (2020-04-02)

#### Merged Pull Requests - complete overhaul of the windows-service config to refplect current best practice

- adding --update-condition funtionality that was added in habitat 1.5.71 [#217](https://github.com/chef-cookbooks/habitat/pull/217) ([sam1el](https://github.com/sam1el))
- added --update-condition funtionality that was added in habitat 1.5.71. See README.MD for info on usage
- complete overhaul of the windows-service config to refplect current best practice

## 1.5.10 (2020-04-01)

#### Merged Pull Requests

- Versioning [#215](https://github.com/chef-cookbooks/habitat/pull/215) ([sam1el](https://github.com/sam1el))

## 1.5.9 (2020-03-30)

#### Merged Pull Requests

- updates to be backwards compatible with 12.20.3+ [#214](https://github.com/chef-cookbooks/habitat/pull/214) ([collinmcneese](https://github.com/collinmcneese))

## 1.5.8 (2020-03-09)

#### Merged Pull Requests

- fixing idempotence on hab_sup_systemd. [#211](https://github.com/chef-cookbooks/habitat/pull/211) ([sam1el](https://github.com/sam1el))

## 1.5.7 (2020-03-06)

- Hab version bumped to 1.5.50

#### Merged Pull Requests

- Hab version [#210](https://github.com/chef-cookbooks/habitat/pull/210) ([sam1el](https://github.com/sam1el))

## 1.5.6 (2020-03-02)

- Cookstyle fixes - [@Xorima](https://github.com/Xorima)
- opensuse requires gzip to be installer for hab install script - [@Xorima](https://github.com/Xorima)
- fix readme - [@Xorima](https://github.com/Xorima)
- updated hab sup resource to include new Application Dashboard options (#206) - [@danielcbright](https://github.com/danielcbright)

#### Merged Pull Requests

- Delete Merged Branches [#209](https://github.com/chef-cookbooks/habitat/pull/209) ([Xorima](https://github.com/Xorima))
- Use Github actions badge in the readme [#208](https://github.com/chef-cookbooks/habitat/pull/208) ([Xorima](https://github.com/Xorima))
- Migrate testing to Github Actions and add support for installing on SUSE [#207](https://github.com/chef-cookbooks/habitat/pull/207) ([Xorima](https://github.com/Xorima))

## 1.5.5 (2020-02-26)

#### Merged Pull Requests

- Extending Windows chef-client compatibility [#205](https://github.com/chef-cookbooks/habitat/pull/205) ([sam1el](https://github.com/sam1el))

## 1.5.4 (2020-02-25)

#### Merged Pull Requests

- adding delay loop to the load function in the service resouce [#204](https://github.com/chef-cookbooks/habitat/pull/204) ([sam1el](https://github.com/sam1el))

## 1.5.3 (2020-02-24)

- Fix linux installer issues

#### Merged Pull Requests

- [BUG FIX] Linux installers [#203](https://github.com/chef-cookbooks/habitat/pull/203) ([sam1el](https://github.com/sam1el))

## 1.5.2 (2020-02-20)

- Fix windows habitat install

#### Merged Pull Requests

- [BUG FIX] Windows install to correct issue #199 [#202](https://github.com/chef-cookbooks/habitat/pull/202) ([sam1el](https://github.com/sam1el))
- Additional cookstyle fixes [#189](https://github.com/chef-cookbooks/habitat/pull/189) ([tas50](https://github.com/tas50))

## 1.5.1 (2020-01-31)

- Fix windows package download URL to use packages.chef.io

#### Merged Pull Requests

- Fix windows package download URL [#198](https://github.com/chef-cookbooks/habitat/pull/198) ([jonlives](https://github.com/jonlives))

## [1.5.0](https://github.com/chef-cookbooks/habitat/tree/1.5.0) (2020-01-29)

- Update cookbook to Habitat 1.5.0
- Fix habitat installs on Windows when using installation archives

#### Merged Pull Requests

- WIP: Update to hab 1.5 and update launchers and windows-service pins [#195](https://github.com/chef-cookbooks/habitat/pull/195) ([jonlives](https://github.com/jonlives))
- Fix Habitat install on windows [#194](https://github.com/chef-cookbooks/habitat/pull/194) ([emachnic](https://github.com/emachnic))

## 0.88.2 (2020-01-24)

- Add support for supervisor HTTP gateway auth token
- Service Properties, Reload/Restart Fixes, Idempotence Improvements

#### Merged Pull Requests

- Service Properties, Reload/Restart Fixes, Idempotence Improvements [#187](https://github.com/chef-cookbooks/habitat/pull/187) ([sirajrauff](https://github.com/sirajrauff))
- Add option for Supervisor HTTP gateway authentication token [#186](https://github.com/chef-cookbooks/habitat/pull/186) ([rarenerd](https://github.com/rarenerd))

## 0.88.1 (2019-11-25)

- Cookstyle 5.10 fixes
- Fixes to properly support loading of services using full ident

#### Merged Pull Requests

- Feature/service full ident fix [#185](https://github.com/chef-cookbooks/habitat/pull/185) ([sirajrauff](https://github.com/sirajrauff))
- Cookstyle 5.10 fixes [#183](https://github.com/chef-cookbooks/habitat/pull/183) ([tas50](https://github.com/tas50))

## [0.88.0](https://github.com/chef-cookbooks/habitat/tree/0.88.0) (2019-10-24)

- Update to hab 0.88.0
- Enable setting of open file limits for hab sup systemd unit file
- Update windows hab-launcher version

#### Merged Pull Requests

- Update to habitat 0.88.0 [#182](https://github.com/chef-cookbooks/habitat/pull/182) ([chef-expeditor[bot]](https://github.com/chef-expeditor[bot]))
- allow setting open file limit on the hab sup systemd unit file [#181](https://github.com/chef-cookbooks/habitat/pull/181) ([devoptimist](https://github.com/devoptimist))
- updating the hab-launcher version to match the dependencies of window… [#179](https://github.com/chef-cookbooks/habitat/pull/179) ([devoptimist](https://github.com/devoptimist))

## [0.83.0](https://github.com/chef-cookbooks/habitat/tree/0.83.0) (2019-07-30)

- Update to hab 0.83.0
- Support hab_config resource under Chef 13
- Fix license acceptance behaviour under Windows
- Support added for health check interval parameter

#### Merged Pull Requests

- Update to habitat 0.83.0 [#177](https://github.com/chef-cookbooks/habitat/pull/177) ([chef-ci](https://github.com/chef-ci))
- Add health check interval option to hab_sup resource [#176](https://github.com/chef-cookbooks/habitat/pull/176) ([gscho](https://github.com/gscho))
- Support config apply for chef 13 [#175](https://github.com/chef-cookbooks/habitat/pull/175) ([gscho](https://github.com/gscho))
- Fix license accept for windows [#174](https://github.com/chef-cookbooks/habitat/pull/174) ([gscho](https://github.com/gscho))
- Add missing end quotes in the README example [#172](https://github.com/chef-cookbooks/habitat/pull/172) ([teknofire](https://github.com/teknofire))

## 0.81.0 (2019-05-29)

- Update to hab 0.81.0
- Implement new habitat license agreement requirements for `hab_install` and `hab_sup` resources

#### Merged Pull Requests

- WIP: Update to hab 0.81.0 (#171)

## [0.81.0](https://github.com/chef-cookbooks/habitat/tree/0.81.0) (2019-05-29)

#### Merged Pull Requests

- WIP: Update to hab 0.81.0 [#171](https://github.com/chef-cookbooks/habitat/pull/171) ([jonlives](https://github.com/jonlives))

## 0.79.1 (2019-04-26)

- Update to habitat 0.79.1

#### Merged Pull Requests

- Update to habitat 0.79.1 [#169](https://github.com/chef-cookbooks/habitat/pull/169) ([chef-ci](https://github.com/chef-ci))

## [0.78.0](https://github.com/chef-cookbooks/habitat/tree/0.78.0) (2019-04-02)

- Update to habitat 0.78.0
- Improve service name matching to include version

#### Merged Pull Requests

- Update to habitat 0.78.0 [#165](https://github.com/chef-cookbooks/habitat/pull/165) ([chef-ci](https://github.com/chef-ci))
- Include version when matching service name [#164](https://github.com/chef-cookbooks/habitat/pull/164) ([gscho](https://github.com/gscho))

## [0.75.0](https://github.com/chef-cookbooks/habitat/tree/0.75.0) (2019-02-22)

-Update to habitat 0.75.0

#### Merged Pull Requests

- Update to habitat 0.75.0 [#161](https://github.com/chef-cookbooks/habitat/pull/161) ([chef-ci](https://github.com/chef-ci))
- Fix expeditor automation and bump to 0.74.0 [#160](https://github.com/chef-cookbooks/habitat/pull/160) ([jonlives](https://github.com/jonlives))

## 0.74.0 (2019-02-14)

- Update to habitat 0.74.0

## 0.73.1 (2019-01-30)

- remove duplicate windows query param

#### Merged Pull Requests

- remove duplicate windows query param [#156](https://github.com/chef-cookbooks/habitat/pull/156) ([skylerto](https://github.com/skylerto))

## 0.73.0 (2019-01-25)

- Update Hab to 0.73.0 and launcher to 9167
- Add binlinking support to hab_package resource
- Support target architectures correctly in API queries
- Improved Windows support

#### Merged Pull Requests

- Update hab to 0.73.0 and launcher to 9167 [#154](https://github.com/chef-cookbooks/habitat/pull/154) ([jonlives](https://github.com/jonlives))
- Install hab-sup from stable release [#153](https://github.com/chef-cookbooks/habitat/pull/153) ([jonlives](https://github.com/jonlives))
- Full Windows Support For Cookbook [#143](https://github.com/chef-cookbooks/habitat/pull/143) ([wduncanfraser](https://github.com/wduncanfraser))
- Add binlink property to hab_package resource. Closes #138 [#139](https://github.com/chef-cookbooks/habitat/pull/139) ([qubitrenegade](https://github.com/qubitrenegade))
- fix incorrect documentation for hab_package action [#142](https://github.com/chef-cookbooks/habitat/pull/142) ([st-h](https://github.com/st-h))
- Support targets for API query [#152](https://github.com/chef-cookbooks/habitat/pull/152) ([skylerto](https://github.com/skylerto))

## 0.67.0 (2018-11-01)

- Update README with accurate maintainer info
- bug fixes for windows on newer chef versions and path seperators
- Update to habitat 0.67.0 (#146)

## 0.63.0 (2018-09-18)

- Update to habitat 0.63.0

## 0.62.1 (2018-09-07)

- Update hab version to 0.62.1 and pin supervisor version to 8380
- Refactor cookbook resources for 0.62.1 compatibility
- Add user_toml resource
- Add remote supervisor support
- Add multiple peer support
- Add auth token support to package resource
- Add basic support for Windows

#### Merged Pull Requests

- Refactor hab_service resource [#124](https://github.com/chef-cookbooks/habitat/pull/124) ([wduncanfraser](https://github.com/wduncanfraser))
- Update to 0.62.1 and launcher 8380 [#129](https://github.com/chef-cookbooks/habitat/pull/129) ([jonlives](https://github.com/jonlives))
- Added auth token support to package resource [#125](https://github.com/chef-cookbooks/habitat/pull/125) ([wduncanfraser](https://github.com/wduncanfraser))
- Updated Supervisor Resource for 0.56 and to Support Auth Token [#123](https://github.com/chef-cookbooks/habitat/pull/123) ([wduncanfraser](https://github.com/wduncanfraser))
- Added user-toml resource [#121](https://github.com/chef-cookbooks/habitat/pull/121) ([wduncanfraser](https://github.com/wduncanfraser))
- Change expeditor notification channel [#128](https://github.com/chef-cookbooks/habitat/pull/128) ([mivok](https://github.com/mivok))
- adding supervisor and service multiple peering support [#101](https://github.com/chef-cookbooks/habitat/pull/101) ([jkerry](https://github.com/jkerry))
- Basic support for windows platform [#89](https://github.com/chef-cookbooks/habitat/pull/89) ([skylerto](https://github.com/skylerto))
- Allow any channel in a service [#120](https://github.com/chef-cookbooks/habitat/pull/120) ([jsirex](https://github.com/jsirex))
- fix hashbang in expeditor update script [#118](https://github.com/chef-cookbooks/habitat/pull/118) ([joshbrand](https://github.com/joshbrand))

## 0.59.0 (2018-07-17)

- Update README to reflect new version of Hab
- address chef 14.3.x shell_out deprecations
- fix shell_out_compact deprecation
- move to after tempfile creation
- Update CHANGELOG.md with details from pull request #111
- Use the new kitchen config file names
- Cookstyle fixes

#### Merged Pull Requests

- address chef 14.3.x shell_out deprecations [#111](https://github.com/chef-cookbooks/habitat/pull/111) ([lamont-granquist](https://github.com/lamont-granquist))

## 0.57.0 (2018-06-19)

- Fix #103
- Add @jonlives as a maintainer
- Source helper functions script

#### Merged Pull Requests

- Source helper functions script [#105](https://github.com/chef-cookbooks/habitat/pull/105) ([jtimberman](https://github.com/jtimberman))
- Fix #103 and remove options from svc start [#104](https://github.com/chef-cookbooks/habitat/pull/104) ([jonlives](https://github.com/jonlives))

## 0.56.1 (2018-06-06)

- Support passing TMPDIR attribute to Habitat install.sh script. Addresses Issue #90
- Add: bldr_url property for hab_sup
- Fix hab_svc when using custom ip:port for supervisor
- Include toml in the bundle
- Update CHANGELOG.md with details from pull request #96

#### Merged Pull Requests

- Fix hab_svc when using custom ip:port for supervisor [#96](https://github.com/chef-cookbooks/habitat/pull/96) ([JonathanTron](https://github.com/JonathanTron))
- Add: bldr_url property for hab_sup [#93](https://github.com/chef-cookbooks/habitat/pull/93) ([Atalanta](https://github.com/Atalanta))
- Support passing TMPDIR attribute to Habitat install.sh script. #90 [#91](https://github.com/chef-cookbooks/habitat/pull/91) ([qubitrenegade](https://github.com/qubitrenegade))
- Include toml in the bundle [#100](https://github.com/chef-cookbooks/habitat/pull/100) ([jtimberman](https://github.com/jtimberman))

## 0.56.0 (2018-06-05)

- Update for 0.56.0
- Cookstyle fix
- Disable FC113 for now
- Update the platforms we test
- Update CHANGELOG.md with details from pull request #97

## 0.55.0 (2018-03-22)

- Adding ability to use local repos
- Add expeditor configuration
- update for 0.55.0

## 0.54.0 (2018-02-22)

- Add auto_update property to hab_sup resource.
- update for 0.54.0 release

## 0.53.0 (2018-02-07)

- Set supervisor service to enable
- Remove the legacy version property
- Update copyrights and format
- Test on the latest Fedora
- Remove the suite from dokken.
- Move installation into config and package
- Use a non-deprecated Fauxhai mock
- Remove author info from the test recipe
- Remove the install test recipe
- Remove the ChefSpec matchers
- Make sure package and curl are installed in the install resource
- Add Debian 7+ to the readme as supported
- Allow nameless hab_install resource
- Turns out we don't even need to install before installing the sup
- Update the hab_install readme examples
- update to habitat 0.53.0

## 0.52.0 (2018-01-23)

- Remove Debian 7 testing
- Remove stove gem that's in ChefDK now
- Align Chef in readme with Chef in metadata
- Format readme markdown
- Remove implementation detail
- Actions are symbols so document them that way
- Remove reference to old Hab since we require the latest now
- update to habitat 0.52.0

## 0.51.0 (2018-01-08)

- Update for Habitat version 0.51.0

## 0.50.3 (2017-12-04)

- Update for Habitat version 0.50.3

## 0.40.0 (2017-11-30)

- Update for Habitat version 0.40.0

## 0.39.2 (2017-11-28)

- Add Supervisor service support for non-Systemd platforms

Development environment/CI changes:

- need to install toml gem for travis
- Ignore failure when installing from acceptance

## 0.39.1 (2017-11-27)

- update for 0.39.1
- fix rubocop findings too

## 0.39.0 (2017-11-17)

- Install version 0.39.0
- Defer running check to a predicate method in service resource

## 0.38.0 (2017-10-30)

- update version to install for habitat 0.38.0

## 0.37.1 (2017-10-26)

- create user in `hab_install`

## 0.37.0 (2017-10-19)

- update for habitat 0.37.0 release

## 0.36.0 (2017-10-09)

- Simplify `Chef::Provider::Package::Hart#current_versions`.
- honor options from package provider
- update for habitat 0.36.0

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
