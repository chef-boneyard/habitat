require 'spec_helper'

describe 'test::install_for_chefspec' do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: '16.04'
    ).converge(described_recipe)
  end

  context 'when compiling the install recipe for chefspec' do
    it 'install habitat' do
      expect(chef_run).to install_hab_install('install habitat')
    end

    it 'installs habitat with a depot url' do
      expect(chef_run).to install_hab_install('install habitat with depot url')
        .with(bldr_url: 'https://localhost')
    end

    it 'installs habitat with tmp_dir' do
      expect(chef_run).to install_hab_install('install habitat with tmp_dir')
        .with(tmp_dir: '/foo/bar')
    end
  end
end
