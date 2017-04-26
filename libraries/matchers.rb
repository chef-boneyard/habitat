#
# Copyright 2016, Chef Software, Inc.
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

if defined?(ChefSpec)
  ChefSpec.define_matcher :hab_install
  ChefSpec.define_matcher :hab_package
  ChefSpec.define_matcher :hab_service
  ChefSpec.define_matcher :hab_sup
  ChefSpec.define_matcher :hab_sup_systemd

  def install_hab_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_install, :install, resource_name)
  end

  def upgrade_hab_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_install, :upgrade, resource_name)
  end

  def install_hab_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_package, :install, resource_name)
  end

  def remove_hab_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_package, :remove, resource_name)
  end

  def load_hab_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_service, :load, resource_name)
  end

  def unload_hab_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_service, :unload, resource_name)
  end

  def start_hab_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_service, :start, resource_name)
  end

  def stop_hab_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_service, :stop, resource_name)
  end

  def run_hab_sup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_sup, :run, resource_name)
  end

  def run_hab_sup_systemd(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:hab_sup_systemd, :run, resource_name)
  end
end
