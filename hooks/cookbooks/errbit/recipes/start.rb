service 'nginx' do
  ignore_failure true
  provider Chef::Provider::Service::Upstart
  action :start
end

service 'nginx' do
  action :reload
  ignore_failure true
  provider Chef::Provider::Service::Upstart
end

service 'errbit' do
  ignore_failure true
  provider Chef::Provider::Service::Upstart
  action :start
end


