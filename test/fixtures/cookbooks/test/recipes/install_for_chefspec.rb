# This recipe is used for running the `install_spec` tests, it should
# not be used in the other recipes.
hab_install "install habitat"

hab_install "install habitat with version" do
  version "0.12.0"
end

hab_install "install habitat with depot url" do
  depot_url "https://localhost/v1/depot"
end
