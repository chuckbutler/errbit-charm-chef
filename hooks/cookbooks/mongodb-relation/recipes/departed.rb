 
package "mongodb-10gen" do
   action :install
  end


  #deploy the backup data
  execute "mongorestore" do
    command "mongorestore -h localhost -d errbit $CHARM_DIR/mongo-data/errbit/"
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
