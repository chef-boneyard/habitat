# This recipe is used for running the `install_spec` tests, it should
# not be used in the other recipes.
hab_install 'install habitat'

hab_install 'install habitat with depot url' do
  bldr_url 'https://localhost'
end

hab_install 'install habitat with tmp_dir' do
  tmp_dir '/foo/bar'
end
