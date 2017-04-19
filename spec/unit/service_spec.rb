require "spec_helper"

describe "test::service" do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: "ubuntu",
      version: "16.04"
    ).converge(described_recipe)
  end

  context "when compiling the service recipe for chefspec" do
    it "loads service" do
      expect(chef_run).to load_hab_service("core/nginx")
    end

    it "loads a service with sup options" do
      expect(chef_run).to load_hab_service("core/haproxy").with(
        sup_options: "--topology leader"
      )
    end

    it "stops service" do
      expect(chef_run).to stop_hab_service("core/redis stop")
    end

    it "unloads service" do
      expect(chef_run).to unload_hab_service("core/haproxy")
    end
  end
end
