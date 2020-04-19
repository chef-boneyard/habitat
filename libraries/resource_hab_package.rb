#
# Author:: AJ Christensen (<aj@chef.io>)
# Copyright:: Copyright 2008-2018, Chef Software, Inc.
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

require 'chef/resource/package'

class Chef
  class Resource
    class HartPackage < Chef::Resource::Package
      resource_name :hab_package
      provides :hab_package

      property :bldr_url, String, default: 'https://bldr.habitat.sh'
      property :channel, String, default: 'stable'
      property :auth_token, String
      property :binlink, equal_to: [true, false, :force], default: false
      property :keep_latest, String
      property :exclude, String
      property :no_deps, equal_to: [true, false], default: false
    end
  end
end
