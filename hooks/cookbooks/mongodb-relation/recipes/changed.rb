require 'securerandom'

mongodb = {
	host: relation_get['hostname'],
	port: relation_get['port'],
	database: 'errbit' 
	}

# This failout condition will do nothing
# if we cannot find the relationship details.

if [:host, :port].any? { |attr| mongodb[attr].nil? || mongodb[attr].empty? }
  juju-log("Waiting for all attributes to be set")
else
 
  template "/home/errbit/errbit/config/mongoid.yml" do
    variables({
      mongo_uri: "mongodb://#{mongodb[:host]}:#{mongodb[:port]}/#{mongodb[:database]}",
    })
    user 'errbit'
    group 'errbit'
    mode '0644'
    source "mongoid.yml.erb"
    cookbook "errbit"
    action :create
  end

  #deploy the backup data
  execute "mongorestore" do
    command "mongorestore -h #{relation_get['hostname']} -d errbit $CHARM_DIR/mongo-data/errbit/"
  end

  service 'errbit' do
    ignore_failure true
    provider Chef::Provider::Service::Upstart
    action :restart
  end

  package "mongodb-10gen" do
    action :purge
  end
 
  execute "touch $CHARM_DIR/.mongodb" do
    action :nothing
  end

end
