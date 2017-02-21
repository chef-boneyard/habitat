require "spec_helper"

describe "test::service" do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: "ubuntu",
      version: "16.04"
    ).converge(described_recipe)
  end

  context "when compiling the service recipe" do
    it "creates a hab user" do
      expect(chef_run).to create_user("hab")
    end

    it "starts the core/nginx service" do
      expect(chef_run).to start_hab_service("core/nginx")
    end

    it "enables the core/redis service" do
      expect(chef_run).to enable_hab_service("core/redis")
    end

    it "enables core/redis with an Array of ExecStart options" do
      expect(chef_run).to enable_hab_service("core/redis").with(
        exec_start_options: ["--listen-gossip 9999", "--listen-http 9998"]
      )
    end

    it "takes ExecStart options for core/haproxy service" do
      expect(chef_run).to start_hab_service("core/haproxy").with(
        exec_start_options: "--permanent-peer"
      )
    end
  end
end
