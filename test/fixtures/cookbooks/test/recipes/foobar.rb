reboot 'now' do
  action :nothing
  reason 'Need to reboot because SSMS is finished.'
  delay_mins 5
end

windows_package '7zip' do
  source 'http://www.7-zip.org/a/7z938-x64.msi'
  action :install
  notifies :request_reboot, 'reboot[now]', :delayed
end
