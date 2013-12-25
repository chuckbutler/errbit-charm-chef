
service 'nginx' do
  action :restart
  ignore_failure true
  provider Chef::Provider::Service::Upstart
end

service 'errbit' do
  ignore_failure true
  provider Chef::Provider::Service::Upstart
  action :start
end

juju_Port "port[80]" do
  action :open
end
