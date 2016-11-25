require "spec_helper"

describe "habitat::default" do
  let!(:chef_runner) do
    ChefSpec::ServerRunner.new(
      platform: "ubuntu",
      version: "16.04"
    )
  end

  def chef_converge(package = nil)
    chef_runner.node.normal["habitat"]["package"] = package
    chef_runner
  end

  context "when attribute for package is set" do
    cached(:chef_run) do
      chef_converge(package = "core/redis").converge(described_recipe)
    end

    it "creates a hab user" do
      expect(chef_run).to create_user("hab")
    end

    it "installs habitat" do
      expect(chef_run).to install_hab_install("install habitat")
    end

    it "installs core/redis" do
      expect(chef_run).to install_hab_package("core/redis")
    end

    it "starts the core/redis service" do
      expect(chef_run).to start_hab_service("core/redis")
    end

    it "enables the core/redis service" do
      expect(chef_run).to enable_hab_service("core/redis")
    end
  end

  context "when attribute for package is not set" do
    cached(:chef_run) do
      chef_converge.converge(described_recipe)
    end

    it "creates a hab user" do
      expect(chef_run).to create_user("hab")
    end

    it "installs habitat" do
      expect(chef_run).to install_hab_install("install habitat")
    end

    it "does not install core/redis" do
      expect(chef_run).not_to install_hab_package("core/redis")
    end

    it "does not start core/redis service" do
      expect(chef_run).not_to start_hab_service("core/redis")
    end

    it "does not enable core/redis service" do
      expect(chef_run).not_to enable_hab_service("core/redis")
    end
  end
end
