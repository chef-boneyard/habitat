require "spec_helper"

describe "test::package" do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: "ubuntu",
      version: "16.04"
    ).converge(described_recipe)
  end

  context "when compiling the package recipe" do
    it "installs core/redis" do
      expect(chef_run).to install_hab_package("core/redis")
    end

    it "installs lamont-granquist/ruby with a specific version" do
      expect(chef_run).to install_hab_package("lamont-granquist/ruby")
        .with(version: "2.3.1")
    end

    it "installs core/bundler with a specific release" do
      expect(chef_run).to install_hab_package("core/bundler")
        .with(version: "1.13.3/20161011123917")
    end

    it "installs core/hab-sup with a specific depot url" do
      expect(chef_run).to install_hab_package("core/hab-sup")
        .with(depot_url: "http://app.acceptance.habitat.sh/v1/depot")
    end
  end
end
