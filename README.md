
Note:

This is a cookbook to rapidly prototype habitat resources prior to inclusion to core chef.

- APIs are subject to change.

- Code style will adhere to chef-core coding style and should not be copied, this is not a
  good example cookbook for cookbook authors.

Usage:

```ruby
hab_install "install habitat"
```

```ruby
hab_package "core/redis"

hab_package "core/redis" do
  version "3.2.3"
end

hab_package "core/redis" do
  version "3.2.3/20160920131015"
end
```
