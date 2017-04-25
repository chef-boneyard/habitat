require 'spec_helper'

describe 'test::install_for_chefspec' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: '16.04'
    ).converge(described_recipe)
  end

  context 'when compiling the install recipe for chefspec' do
    it 'installs habitat' do
      expect(chef_run).to install_hab_install('install habitat')
    end

    it 'installs habitat with a version' do
      expect(chef_run).to install_hab_install('install habitat with version')
        .with(version: '0.12.0')
    end

    it 'installs habitat with a depot url' do
      expect(chef_run).to install_hab_install('install habitat with depot url')
        .with(depot_url: 'https://localhost/v1/depot')
    end
  end
end
