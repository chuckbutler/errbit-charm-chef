
#drop the templates
template "/home/errbit/errbit/config/config.yml" do
  owner "errbit"
  group "errbit"
  mode "0660"
  source "config.yml.erb"
  variables({
   confirm_resolve: config_get['confirm_resolve'],
   gravatar: config_get['gravatar'],
   smtp_host: config_get['smtp_host'],
   smtp_domain: config_get['smtp_domain'],
   smtp_port: config_get['smtp_port'],
   smtp_starttls_auto: config_get['smtp_starttls_auto'],
   smtp_user: config_get['smtp_user'],
   smtp_pass: config_get['smtp_pass']
   })
end

template "/home/errbit/errbit/config/mongoid.yml" do
  owner "errbit"
  group "errbit"
  mode "0660"
  source "mongoid.yml.erb"
  variables({ mongo_uri: "mongodb://localhost:27017/errbit" })
end

#delete existing upstart templates if they exist
template "/etc/init/errbit.conf" do
  action :delete
end

template "/etc/init/errbit-web.conf" do
  action :delete
end

#setup upstart templates
template "/etc/init/errbit.conf" do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  source 'errbit.conf.erb'
end

template "/etc/init/errbit-web.conf" do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  source 'errbit-web.conf.erb'
end


template "/home/errbit/errbit/config/unicorn.rb" do
  action :create
  owner 'errbit'
  group 'errbit'
  mode 0644
  source 'unicorn.rb.erb'
  variables({
    unicorn_workers: config_get['unicorn_workers']
  })
end


#setup the NGINX configuration
template "/etc/nginx/sites-available/errbit" do
  action :create
  owner 'root'
  group 'root'
  mode 0644
  source 'errbit-nginx.erb'
  variables({
    hostname: config_get['hostname']
  })
end

link "/etc/nginx/sites-enabled/errbit" do
  action :create
  to "/etc/nginx/sites-available/errbit"
end

#TODO: document that we remove the default nginx vhost
link "/etc/nginx/sites-enabled/default" do
  action :delete
end


#Prep the post-deployment script to circumvent chef's personality conflicts
template "/tmp/bundler.sh" do
  action :create
  owner 'errbit'
  group 'errbit'
  mode 0777
  source 'bundler.sh.erb'
end

juju_log("Completed template generation")
