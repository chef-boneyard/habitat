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

resource_name :hab_install

property :name, String, default: '' # ~FC108 This allows for bare names like hab_install
property :install_url, String, default: 'https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh'
property :bldr_url, String
property :channel, String
property :create_user, [true, false], default: true
property :tmp_dir, String

action :install do
  package %w(curl tar)

  if new_resource.create_user
    group 'hab'

    user 'hab' do
      gid 'hab'
      system true
    end
  end

  if ::File.exist?(hab_path)
    cmd = shell_out!([hab_path, '--version', hab_version])
    version = %r{hab (\d*\.\d*\.\d[^\/]*)}.match(cmd.stdout)[1]
    return if version == hab_version
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

action :upgrade do
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

action_class do
  HAB_VERSION = '0.62.0'.freeze

  def hab_version
    HAB_VERSION
  end

  def hab_path
    if platform_family?('mac_os_x')
      '/usr/local/bin/hab'
    elsif platform_family?('windows')
      Chef::Log.warn 'Habitat installation on Windows is not yet supported by this cookbook.'
      Chef::Log.warn 'The installation location on Windows will probably change in the future.'
      'C:/Program Files/Habitat/hab.exe'
    else
      '/bin/hab'
    end
  end

  def hab_command
    cmd = ["bash #{Chef::Config[:file_cache_path]}/hab-install.sh", "-v #{hab_version}"]
    cmd.join(' ')
  end
end
