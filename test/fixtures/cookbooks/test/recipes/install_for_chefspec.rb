# This recipe is used for running the `install_spec` tests, it should
# not be used in the other recipes.
hab_install 'install habitat' do
  license 'accept'
end

hab_install 'install habitat with depot url' do
  bldr_url 'https://localhost'
  license 'accept'
end

hab_install 'install habitat with tmp_dir' do
  tmp_dir '/foo/bar'
  license 'accept'
end
