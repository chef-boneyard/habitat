# Habitat Cookbook CHANGELOG

This file is used to list changes made in each version of the habitat cookbook.

## 2.0.1 (2020-04-21)

- correct package name for the windows zip file being used. also added a step to create c:\habitat directory since powershell was failing on that step. placeholder for upgrade enhancement - [@sam1el](https://github.com/sam1el)
- [BUG_FIX] Issue #199 fixeed install on Windows - [@sam1el](https://github.com/sam1el)
- removing unwanted tests - [@sam1el](https://github.com/sam1el)
- fixed bad syntax in install resource - [@sam1el](https://github.com/sam1el)
- Remove a bogus platform_family? check - [@tas50](https://github.com/tas50)
- Remove old Foodcritic comments - [@tas50](https://github.com/tas50)
- Add testing with Github Actions - [@tas50](https://github.com/tas50)
- Update systems we test on in Test Kitchen - [@tas50](https://github.com/tas50)
- Allow versions in the specs to float a bit - [@tas50](https://github.com/tas50)
- Remove the .foodcritic file - [@tas50](https://github.com/tas50)
- Update the boxes in Kitchen and the Travis config - [@tas50](https://github.com/tas50)
- Remove github actions for now - [@tas50](https://github.com/tas50)
- Use public windows boxes and fix travis failures - [@tas50](https://github.com/tas50)
- Run delivery in Github Actions - [@tas50](https://github.com/tas50)
- Disable cookstyle for old spec - [@tas50](https://github.com/tas50)
- Update CHANGELOG.md with details from pull request #189
- removed bad unit test - [@sam1el](https://github.com/sam1el)
- fixing delivery errors (#6) - [@sam1el](https://github.com/sam1el)
- [BUG FIX] Windows install to correct issue #199 (#202) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #202
- Release 1.15.2 - [@jonlives](https://github.com/jonlives)
- Merge branch 'master' of github.com:chef-cookbooks/habitat - [@sam1el](https://github.com/sam1el)
- correction to systemd template - [@sam1el](https://github.com/sam1el)
- corrected the broken unit test for sup_spec.rb to match the new systemd template - [@sam1el](https://github.com/sam1el)
- fixed broken syntax in resourece/service.rb line 236-237 - [@sam1el](https://github.com/sam1el)
- extended the delay on a few service tests to allow more time to load - [@sam1el](https://github.com/sam1el)
- bumped hab version to newest stable - [@sam1el](https://github.com/sam1el)
- reverted back to 1.5.0 and removed 2 settings from systemd - [@sam1el](https://github.com/sam1el)
- removed unwanted systemd test - [@sam1el](https://github.com/sam1el)
- changing kernel detection syntax to to_i rather then to_f - [@sam1el](https://github.com/sam1el)
- corrected integers in the install and hab_packaged provider resources for the kernel version check - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #203
- Releasing 1.5.3 - [@jonlives](https://github.com/jonlives)
- adding delay loop to the load function in the service resouce - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #204
- release 1.5.4 - [@sam1el](https://github.com/sam1el)
- Extending Windows chef-client compatibility  (#205) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #205
- release 1.5.5 - [@sam1el](https://github.com/sam1el)
- corrections to changelog.md - [@sam1el](https://github.com/sam1el)
- Update README.md - [@jonlives](https://github.com/jonlives)
- Move Dokken testing to github actions - [@Xorima](https://github.com/Xorima)
- Example Windows github actions - [@Xorima](https://github.com/Xorima)
- ubuntu is 1604 not 16.04 - [@Xorima](https://github.com/Xorima)
- Bye bye Travis - [@Xorima](https://github.com/Xorima)
- Minor readme fixes - [@Xorima](https://github.com/Xorima)
- Cookstyle fixes - [@Xorima](https://github.com/Xorima)
- opensuse requires gzip to be installer for hab install script - [@Xorima](https://github.com/Xorima)
- Update CHANGELOG.md with details from pull request #207
- fix readme - [@Xorima](https://github.com/Xorima)
- Delete Merged Branches - [@Xorima](https://github.com/Xorima)
- Update CHANGELOG.md with details from pull request #208
- Update CHANGELOG.md with details from pull request #209
- updated hab sup resource to include new Application Dashboard options (#206) - [@danielcbright](https://github.com/danielcbright)
- Update CHANGELOG.md with details from pull request #206
- release 1.5.6 - [@sam1el](https://github.com/sam1el)
- changing version in the VERSION file - [@sam1el](https://github.com/sam1el)
- Hab version (#210) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #210
- release 1.5.7 - [@sam1el](https://github.com/sam1el)
- fixing idempotence on hab_sup_systemd. (#211) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #211
- release 1.5.8 - [@sam1el](https://github.com/sam1el)
- updates to be backwards compatible with 12.20.3+ (#214) - [@collinmcneese](https://github.com/collinmcneese)
- Update CHANGELOG.md with details from pull request #214
- release 1.5.9 - [@sam1el](https://github.com/sam1el)
- Versioning (#215) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #215
- release v1.5.10 - [@sam1el](https://github.com/sam1el)
- adding --update-condition funtionality that was added in habitat 1.5.71 (#217) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #217
- release vl.6.0 - [@sam1el](https://github.com/sam1el)
- correcting a breaking issue in install resource (#219) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #219
- release v1.6.1 - [@sam1el](https://github.com/sam1el)
- removing update-confition defaults and tests (#221) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #221
- release v1.6.2 - [@sam1el](https://github.com/sam1el)
- changing the windows service cofig to better reflect newer functional… (#223) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #223
- release v1.7.0 - [@sam1el](https://github.com/sam1el)
- Issue/eventstream (#7) - [@sam1el](https://github.com/sam1el)
- adds windows Github Actions testing for issue #193 (#224) - [@collinmcneese](https://github.com/collinmcneese)
- Update CHANGELOG.md with details from pull request #224
- master merge - [@sam1el](https://github.com/sam1el)
- Cookstyle 6.2.9 Fixes - [@xorimabot](https://github.com/xorimabot)
- Update CHANGELOG.md with details from pull request #225
- merging cookstyle changes - [@sam1el](https://github.com/sam1el)
- correcting issues - [@sam1el](https://github.com/sam1el)
- Standardise files with files in chef-cookbooks/repo-management - [@xorimabot](https://github.com/xorimabot)
- Standardise files with files in chef-cookbooks/repo-management - [@xorimabot](https://github.com/xorimabot)
- Update CHANGELOG.md with details from pull request #226
- merging cookstyle changes - [@sam1el](https://github.com/sam1el)
- merge with master again to get all of bot changes - [@sam1el](https://github.com/sam1el)
- merge with master again to correct local branch - [@sam1el](https://github.com/sam1el)
- Update/overhaul (#10) - [@sam1el](https://github.com/sam1el)
- Standardise files with files in chef-cookbooks/repo-management (#229) - [@xorimabot](https://github.com/xorimabot)
- Update CHANGELOG.md with details from pull request #229
- Update/overhaul (#11) - [@sam1el](https://github.com/sam1el)
- Merge branch 'master' into master - [@sam1el](https://github.com/sam1el)
- requested PR corrections - [@sam1el](https://github.com/sam1el)
- needed to uncomment pipeline files - [@sam1el](https://github.com/sam1el)
- removing old code from install resource - [@sam1el](https://github.com/sam1el)
- adding instal tests back to pipeline - [@sam1el](https://github.com/sam1el)
- fixes comment line in kitchen.yml throwing errors - [@collinmcneese](https://github.com/collinmcneese)
- fixes suite names for newly added suites with dokken - [@collinmcneese](https://github.com/collinmcneese)
- fixed bad syntax in kitchen.yml - [@sam1el](https://github.com/sam1el)
- Merge branch 'master' of github.com:sam1el/habitat - [@sam1el](https://github.com/sam1el)
- made changes to the hab_sup_windows resource to ensure it functions as expected - [@sam1el](https://github.com/sam1el)
- correcting cookstyle issue - [@sam1el](https://github.com/sam1el)

## 2.0.0 (2020-04-21)

- correct package name for the windows zip file being used. also added a step to create c:\habitat directory since powershell was failing on that step. placeholder for upgrade enhancement - [@sam1el](https://github.com/sam1el)
- [BUG_FIX] Issue #199 fixeed install on Windows - [@sam1el](https://github.com/sam1el)
- removing unwanted tests - [@sam1el](https://github.com/sam1el)
- fixed bad syntax in install resource - [@sam1el](https://github.com/sam1el)
- Remove a bogus platform_family? check - [@tas50](https://github.com/tas50)
- Remove old Foodcritic comments - [@tas50](https://github.com/tas50)
- Add testing with Github Actions - [@tas50](https://github.com/tas50)
- Update systems we test on in Test Kitchen - [@tas50](https://github.com/tas50)
- Allow versions in the specs to float a bit - [@tas50](https://github.com/tas50)
- Remove the .foodcritic file - [@tas50](https://github.com/tas50)
- Update the boxes in Kitchen and the Travis config - [@tas50](https://github.com/tas50)
- Remove github actions for now - [@tas50](https://github.com/tas50)
- Use public windows boxes and fix travis failures - [@tas50](https://github.com/tas50)
- Run delivery in Github Actions - [@tas50](https://github.com/tas50)
- Disable cookstyle for old spec - [@tas50](https://github.com/tas50)
- Update CHANGELOG.md with details from pull request #189
- removed bad unit test - [@sam1el](https://github.com/sam1el)
- fixing delivery errors (#6) - [@sam1el](https://github.com/sam1el)
- [BUG FIX] Windows install to correct issue #199 (#202) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #202
- Release 1.15.2 - [@jonlives](https://github.com/jonlives)
- Merge branch 'master' of github.com:chef-cookbooks/habitat - [@sam1el](https://github.com/sam1el)
- correction to systemd template - [@sam1el](https://github.com/sam1el)
- corrected the broken unit test for sup_spec.rb to match the new systemd template - [@sam1el](https://github.com/sam1el)
- fixed broken syntax in resourece/service.rb line 236-237 - [@sam1el](https://github.com/sam1el)
- extended the delay on a few service tests to allow more time to load - [@sam1el](https://github.com/sam1el)
- bumped hab version to newest stable - [@sam1el](https://github.com/sam1el)
- reverted back to 1.5.0 and removed 2 settings from systemd - [@sam1el](https://github.com/sam1el)
- removed unwanted systemd test - [@sam1el](https://github.com/sam1el)
- changing kernel detection syntax to to_i rather then to_f - [@sam1el](https://github.com/sam1el)
- corrected integers in the install and hab_packaged provider resources for the kernel version check - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #203
- Releasing 1.5.3 - [@jonlives](https://github.com/jonlives)
- adding delay loop to the load function in the service resouce - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #204
- release 1.5.4 - [@sam1el](https://github.com/sam1el)
- Extending Windows chef-client compatibility  (#205) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #205
- release 1.5.5 - [@sam1el](https://github.com/sam1el)
- corrections to changelog.md - [@sam1el](https://github.com/sam1el)
- Update README.md - [@jonlives](https://github.com/jonlives)
- Move Dokken testing to github actions - [@Xorima](https://github.com/Xorima)
- Example Windows github actions - [@Xorima](https://github.com/Xorima)
- ubuntu is 1604 not 16.04 - [@Xorima](https://github.com/Xorima)
- Bye bye Travis - [@Xorima](https://github.com/Xorima)
- Minor readme fixes - [@Xorima](https://github.com/Xorima)
- Cookstyle fixes - [@Xorima](https://github.com/Xorima)
- opensuse requires gzip to be installer for hab install script - [@Xorima](https://github.com/Xorima)
- Update CHANGELOG.md with details from pull request #207
- fix readme - [@Xorima](https://github.com/Xorima)
- Delete Merged Branches - [@Xorima](https://github.com/Xorima)
- Update CHANGELOG.md with details from pull request #208
- Update CHANGELOG.md with details from pull request #209
- updated hab sup resource to include new Application Dashboard options (#206) - [@danielcbright](https://github.com/danielcbright)
- Update CHANGELOG.md with details from pull request #206
- release 1.5.6 - [@sam1el](https://github.com/sam1el)
- changing version in the VERSION file - [@sam1el](https://github.com/sam1el)
- Hab version (#210) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #210
- release 1.5.7 - [@sam1el](https://github.com/sam1el)
- fixing idempotence on hab_sup_systemd. (#211) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #211
- release 1.5.8 - [@sam1el](https://github.com/sam1el)
- updates to be backwards compatible with 12.20.3+ (#214) - [@collinmcneese](https://github.com/collinmcneese)
- Update CHANGELOG.md with details from pull request #214
- release 1.5.9 - [@sam1el](https://github.com/sam1el)
- Versioning (#215) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #215
- release v1.5.10 - [@sam1el](https://github.com/sam1el)
- adding --update-condition funtionality that was added in habitat 1.5.71 (#217) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #217
- release vl.6.0 - [@sam1el](https://github.com/sam1el)
- correcting a breaking issue in install resource (#219) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #219
- release v1.6.1 - [@sam1el](https://github.com/sam1el)
- removing update-confition defaults and tests (#221) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #221
- release v1.6.2 - [@sam1el](https://github.com/sam1el)
- changing the windows service cofig to better reflect newer functional… (#223) - [@sam1el](https://github.com/sam1el)
- Update CHANGELOG.md with details from pull request #223
- release v1.7.0 - [@sam1el](https://github.com/sam1el)
- Issue/eventstream (#7) - [@sam1el](https://github.com/sam1el)
- adds windows Github Actions testing for issue #193 (#224) - [@collinmcneese](https://github.com/collinmcneese)
- Update CHANGELOG.md with details from pull request #224
- master merge - [@sam1el](https://github.com/sam1el)
- Cookstyle 6.2.9 Fixes - [@xorimabot](https://github.com/xorimabot)
- Update CHANGELOG.md with details from pull request #225
- merging cookstyle changes - [@sam1el](https://github.com/sam1el)
- correcting issues - [@sam1el](https://github.com/sam1el)
- Standardise files with files in chef-cookbooks/repo-management - [@xorimabot](https://github.com/xorimabot)
- Standardise files with files in chef-cookbooks/repo-management - [@xorimabot](https://github.com/xorimabot)
- Update CHANGELOG.md with details from pull request #226
- merging cookstyle changes - [@sam1el](https://github.com/sam1el)
- merge with master again to get all of bot changes - [@sam1el](https://github.com/sam1el)
- merge with master again to correct local branch - [@sam1el](https://github.com/sam1el)
- Update/overhaul (#10) - [@sam1el](https://github.com/sam1el)
- Standardise files with files in chef-cookbooks/repo-management (#229) - [@xorimabot](https://github.com/xorimabot)
- Update CHANGELOG.md with details from pull request #229
- Update/overhaul (#11) - [@sam1el](https://github.com/sam1el)
- Merge branch 'master' into master - [@sam1el](https://github.com/sam1el)
- requested PR corrections - [@sam1el](https://github.com/sam1el)
- needed to uncomment pipeline files - [@sam1el](https://github.com/sam1el)
- removing old code from install resource - [@sam1el](https://github.com/sam1el)
- adding instal tests back to pipeline - [@sam1el](https://github.com/sam1el)
- fixes comment line in kitchen.yml throwing errors - [@collinmcneese](https://github.com/collinmcneese)
- fixes suite names for newly added suites with dokken - [@collinmcneese](https://github.com/collinmcneese)
- fixed bad syntax in kitchen.yml - [@sam1el](https://github.com/sam1el)
- Merge branch 'master' of github.com:sam1el/habitat - [@sam1el](https://github.com/sam1el)
- made changes to the hab_sup_windows resource to ensure it functions as expected - [@sam1el](https://github.com/sam1el)
- correcting cookstyle issue - [@sam1el](https://github.com/sam1el)
 <!-- latest_release unreleased -->
## Unreleased

- Automated PR: Standardising Files [#229](https://github.com/chef-cookbooks/habitat/pull/229) ([xorimabot](https://github.com/xorimabot))
- Automated PR: Standardising Files [#226](https://github.com/chef-cookbooks/habitat/pull/226) ([xorimabot](https://github.com/xorimabot))
- Automated PR: Cookstyle Changes [#225](https://github.com/chef-cookbooks/habitat/pull/225) ([xorimabot](https://github.com/xorimabot))
- resolved cookstyle error: libraries/provider_hab_package.rb:174:13 convention: `Style/RedundantReturn`
- resolved cookstyle error: libraries/provider_hab_package.rb:176:13 convention: `Style/RedundantReturn`

<!-- latest_release -->
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

#### Merged Pull Requests	- complete overhaul of the windows-service config to refplect current best practice

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

- Extending Windows chef-client compatibility  [#205](https://github.com/chef-cookbooks/habitat/pull/205) ([sam1el](https://github.com/sam1el))

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
- Implement new habitat license agreement requirements for ```hab_install``` and ```hab_sup``` resources

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

* Update Hab to 0.73.0 and launcher to 9167
* Add binlinking support to hab_package resource
* Support target architectures correctly in API queries
* Improved Windows support


#### Merged Pull Requests

- Update hab to 0.73.0 and launcher to 9167 [#154](https://github.com/chef-cookbooks/habitat/pull/154) ([jonlives](https://github.com/jonlives))
- Install hab-sup from stable release [#153](https://github.com/chef-cookbooks/habitat/pull/153) ([jonlives](https://github.com/jonlives))
- Full Windows Support For Cookbook [#143](https://github.com/chef-cookbooks/habitat/pull/143) ([wduncanfraser](https://github.com/wduncanfraser))
- Add binlink property to hab_package resource.  Closes #138 [#139](https://github.com/chef-cookbooks/habitat/pull/139) ([qubitrenegade](https://github.com/qubitrenegade))
- fix incorrect documentation for hab_package action [#142](https://github.com/chef-cookbooks/habitat/pull/142) ([st-h](https://github.com/st-h))
- Support targets for API query [#152](https://github.com/chef-cookbooks/habitat/pull/152) ([skylerto](https://github.com/skylerto))

## 0.67.0 (2018-11-01)

- Update README with accurate maintainer info
- bug fixes for windows on newer chef versions and path seperators
- Update to habitat 0.67.0 (#146)

## 0.63.0 (2018-09-18)

*  Update to habitat 0.63.0

## 0.62.1 (2018-09-07)

* Update hab version to 0.62.1 and pin supervisor version to 8380
* Refactor cookbook resources for 0.62.1 compatibility
* Add user_toml resource
* Add remote supervisor support
* Add multiple peer support
* Add auth token support to package resource
* Add basic support for Windows

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

- Support passing TMPDIR attribute to Habitat install.sh script.  Addresses Issue #90
- Add: bldr_url property for hab_sup
- Fix hab_svc when using custom ip:port for supervisor
- Include toml in the bundle
- Update CHANGELOG.md with details from pull request #96

#### Merged Pull Requests

- Fix hab_svc when using custom ip:port for supervisor [#96](https://github.com/chef-cookbooks/habitat/pull/96) ([JonathanTron](https://github.com/JonathanTron))
- Add: bldr_url property for hab_sup [#93](https://github.com/chef-cookbooks/habitat/pull/93) ([Atalanta](https://github.com/Atalanta))
- Support passing TMPDIR attribute to Habitat install.sh script.  #90 [#91](https://github.com/chef-cookbooks/habitat/pull/91) ([qubitrenegade](https://github.com/qubitrenegade))
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
