
#include the apt cookbook for the LWRPS
include_recipe "apt"

apt_repository "mongodb-10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
end

#TODO: check if db relation exists and short ciruit
package "mongodb-10gen" do
  action :install
end

#install dependencies
package "libxslt-dev" do
  action :install
end

package "libxml2-dev" do
  action :install
end


user "errbit" do
  shell "/bin/bash"
  home "/home/errbit"
  system true
  supports :manage_home => true
  action :create
  uid 3000
end


git "/home/errbit/errbit" do
  repository config_get['repository']
  reference config_get['release']
  action :sync
end

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

#Prep the hack script to circumvent chef's personality conflicts
template "/tmp/bundler.sh" do
  action :create
  owner 'errbit'
  group 'errbit'
  mode 0777
  source 'bundler.sh.erb'
end



directory "/home/errbit/errbit" do
  owner "errbit"
  group "errbit"
  recursive true
end

execute "chown -R errbit:errbit /home/errbit/errbit" do
  action :run
end


