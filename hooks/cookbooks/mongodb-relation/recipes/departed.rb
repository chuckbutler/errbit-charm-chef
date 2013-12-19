 
  package "mongodb-10gen" do
   action :install
  end


mongodb = {
  host: relation_get['hostname'],
  port: relation_get['port'],
  database: 'errbit' 
 }

  directory "/mnt/mongo-data" do
    action :create
    mode '0750'
  end

  #deploy the backup data
  execute "mongodump" do
    command "mongodump -h #{relation_get['hostname']} --port #{relation_get['port']}  -d errbit -o /mnt/mongo-data/errbit/"
    action :nothing
  end




  #deploy the backup data
  execute "mongorestore" do
    command "mongorestore -h localhost -d errbit /mnt/mongo-data/errbit/"
  end


  template "/home/errbit/errbit/config/mongoid.yml" do
    variables({
      mongo_uri: "mongodb://localhost:27017/errbit",
    })
    user "errbit"
    group "errbit"
    mode "0644"
    source "mongoid.yml.erb"
    cookbook "errbit"
    action :create
  end

  service 'errbit' do
    ignore_failure true
    provider Chef::Provider::Service::Upstart
    action :restart
  end


  file "$CHARM_DIR/.mongodb" do
    action :delete
  end
