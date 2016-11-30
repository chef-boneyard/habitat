require "spec_helper"

describe "test::install" do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: "ubuntu",
      version: "16.04"
    ).converge(described_recipe)
  end

  context "when compiling the install recipe" do
    it "installs habitat" do
      expect(chef_run).to install_hab_install("install habitat")
    end
  end

  context "when compiling the install recipe with a version" do
    it "installs habitat" do
      expect(chef_run).to install_hab_install("install habitat with version")
        .with(version: "0.12.0")
    end
  end
end
