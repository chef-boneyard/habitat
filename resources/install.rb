#
# Author:: Thom May (<thom@chef.io>)
# Copyright:: 2017-2018 Chef Software, Inc.
#
# Copyright:: Copyright (c) 2016 Chef Software, Inc.
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
require 'chef/http/simple'

resource_name :hab_install

property :name, String, default: ''
# The following are only used on *nix
property :install_url, String, default: 'https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh'
property :bldr_url, String
property :create_user, [true, false], default: true
property :tmp_dir, String
property :license, String, equal_to: ['accept']

action :install do
  if ::File.exist?(hab_path)
    cmd = shell_out!([hab_path, '--version'].flatten.compact.join(' '))
    version = %r{hab (\d*\.\d*\.\d[^\/]*)}.match(cmd.stdout)[1]
    return if version == hab_version
  end

  if platform_family?('windows')
    # Retrieve version information
    uri = 'https://packages.chef.io/files'
    package_name = 'hab-x86_64-windows'
    zipfile = "#{Chef::Config[:file_cache_path]}/#{package_name}.zip"

    # TODO: Figure out how to properly validate the shasum for windows. Doesn't seem it's published
    # as a .sha265sum like for the linux .tar.gz
    download = "#{uri}/stable/habitat/latest/hab-x86_64-windows.zip"

    remote_file zipfile do
      source download
    end

    archive_file "#{package_name}.zip" do
      path zipfile
      destination "#{Chef::Config[:file_cache_path]}/habitat"
      action :extract
    end

    # Precreate 'c:\habitat to correct powershell errors'
    # The powershell_script was just creating a file called habitat in 'c:/'
    directory 'c:\habitat'

    powershell_script 'installing from archive' do
      code <<-EOH
      Move-Item -Path #{Chef::Config[:file_cache_path]}/habitat/hab-*/* -Destination C:/habitat -Force
      EOH
    end

    # Cleanup for future upgrade purposes
    directory "#{Chef::Config[:file_cache_path]}/habitat" do
      action :delete
      recursive true
    end

    # TODO: This won't self heal if missing until the next upgrade
    windows_path 'C:\habitat' do
      action :add
    end
  else
    package %w(curl tar)

    if new_resource.create_user
      group 'hab'

      user 'hab' do
        gid 'hab'
        system true
      end
    end

    remote_file ::File.join(Chef::Config[:file_cache_path], 'hab-install.sh') do
      source new_resource.install_url
      sensitive true
    end

    execute 'installing with hab-install.sh' do
      command hab_command
      environment(
        {
          'HAB_BLDR_URL' => 'bldr_url',
          'TMPDIR' => 'tmp_dir',
        }.each_with_object({}) do |(var, property), env|
          env[var] = new_resource.send(property.to_sym) if new_resource.send(property.to_sym)
        end
      )
    end
  end
  execute 'hab license accept' if new_resource.license == 'accept'
end

# TODO: What is the point of the upgrade action? We are version locking and the install action safely handles upgrades.
action :upgrade do
  if platform_family?('windows')
    # Retrieve version information
    uri = 'https://packages.chef.io/files'
    package_name = 'hab-latest-x86_64-windows'
    zipfile = "#{Chef::Config[:file_cache_path]}/#{package_name}.zip"

    # TODO: Figure out how to properly validate the shasum for windows. Doesn't seem it's published
    # as a .sha265sum like for the linux .tar.gz
    download = "#{uri}/stable/habitat/latest/hab-x86_64-windows.zip"

    remote_file zipfile do
      source download
    end

    archive_file "#{package_name}.zip" do
      path zipfile
      destination "#{Chef::Config[:file_cache_path]}/habitat"
      overwrite true
      action :extract
    end

    powershell_script 'installing from archive' do
      code <<-EOH
      Move-Item -Path #{Chef::Config[:file_cache_path]}/habitat/#{package_name} -Destination C:/habitat -Force
      EOH
    end

    # TODO: This won't self heal if missing until the next upgrade
    windows_path 'C:\habitat' do
      action :add
    end
  else
    remote_file ::File.join(Chef::Config[:file_cache_path], 'hab-install.sh') do
      source new_resource.install_url
      sensitive true
    end

    execute 'installing with hab-install.sh' do
      command hab_command
      environment(
        {
          'HAB_BLDR_URL' => 'bldr_url',
          'TMPDIR' => 'tmp_dir',
        }.each_with_object({}) do |(var, property), env|
          env[var] = new_resource.send(property.to_sym) if new_resource.send(property.to_sym)
        end
      )
    end
  end
end

action_class do
  include Habitat::Shared

  def hab_path
    if platform_family?('mac_os_x')
      '/usr/local/bin/hab'
    elsif platform_family?('windows')
      'C:/habitat/hab.exe'
    else
      '/bin/hab'
    end
  end

  def hab_command
    cmd = ["bash #{Chef::Config[:file_cache_path]}/hab-install.sh", "-v #{hab_version}"]
    cmd.join(' ')
  end
end
