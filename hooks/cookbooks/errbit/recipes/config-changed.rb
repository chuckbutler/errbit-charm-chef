
class Chef::Recipe
  include AssetHelper
end


#drop the templates
template node[:errbit][:path] + "/config/config.yml" do
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
   smtp_pass: config_get['smtp_pass'],
   sendmail: config_get['use_sendmail']
   })
end

  template node[:errbit][:path] + "/config/mongoid.yml" do
    owner "errbit"
    group "errbit"
    mode "0660"
    source "mongoid.yml.erb"
    variables({ mongo_uri: "mongodb://localhost:27017/errbit" })
    not_if { File.exists?("#{ENV['CHARM_DIR']}/mongodb") }
  end

bash "bundle_deploy" do
  user "errbit"
  cwd node[:errbit][:path]
  code "/usr/bin/env bundle install --without test --deployment"
end

execute "generate_secret_token" do
  user "root"
  cwd node[:errbit][:path]
  command "echo `sudo -u errbit -H bundle exec rake secret` > $CHARM_DIR/secret_token"
  action :run
  not_if { File.exists?("#{ENV['CHARM_DIR']}/secret_token")}
end


template node[:errbit][:path] + "/config/initializers/secret_token.rb" do
  action :create
  source 'secret_token.rb.erb'
  owner "errbit"
  group "errbit"
  variables({
    secret: `cat $CHARM_DIR/secret_token`
    })
end


execute "bootstrap_errbit" do
  user "errbit"
  cwd node[:errbit][:path]
  action :run
  command "bundle exec rake errbit:bootstrap && touch #{node[:errbit][:path]}/.strapped"
  environment ({'RAILS_ENV' => 'production'})
  creates node[:errbit][:path] + "/.strapped"
end



recompile_assets()

execute "cache_git_revision" do
    command "cd #{node[:errbit][:path]} && git rev-parse HEAD > #{ENV['CHARM_DIR']}/errbit_revision"
    action :run
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

execute "nginx_restart" do
  command "service nginx reload"
  action :run
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


template node[:errbit][:path] + "/config/unicorn.rb" do
  action :create
  owner 'errbit'
  group 'errbit'
  mode 0644
  source 'unicorn.rb.erb'
  variables({
    unicorn_workers: config_get['unicorn_workers']
  })
end






