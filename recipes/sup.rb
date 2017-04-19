hab_install "#{cookbook_name}::#{recipe_name}"

hab_package "core/hab-sup"

systemd_unit 'hab-sup.service' do
  content({
    Unit: {
        Description: 'The Habitat Supervisor',
    },
    Service: {
        ExecStart: "/bin/hab sup run",
        Restart: "on-failure",
    },
    Install: {
        WantedBy: "default.target",
    },
  })
  action :create
end

service 'hab-sup' do
  subscribes :restart, 'systemd_unit[hab-sup.service]'
  action :start
end
