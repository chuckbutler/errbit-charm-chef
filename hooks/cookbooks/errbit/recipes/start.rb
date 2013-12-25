
service 'errbit' do
  provider Chef::Provider::Service::Upstart
  action :start
end

