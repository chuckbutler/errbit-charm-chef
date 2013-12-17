require 'securerandom'

mongodb = {
	host: juju_relation['hostname'],
	port: juju_relation['port'],
	database: 'errbit' 
	}


if %i(host port).any? { |attr| mongodb[attr].nil? || mongodb[attr].empty? }
  puts "Waiting for all attributes to be set"
else
 
  template "/home/errbit/errbit/config/database.yml" do
    variables({
      mongo_uri: "mongodb://#{mongodb[:host]}:#{mongodb[:port]}/#{mongodb[:database]}",
    })
    user 'errbit'
    group 'errbit'
    mode '0644'
    action :create
  end

  service 'errbit' do
    ignore_failure true
    provider Chef::Provider::Service::Upstart
    action :restart
  end
end
