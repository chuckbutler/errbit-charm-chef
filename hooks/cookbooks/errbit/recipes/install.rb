
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

package "nginx" do
  action :install
end

execute "service nginx start" do
  action :run
end


package "sendmail" do
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

execute "chown -R errbit:errbit /home/errbit/errbit" do
  action :run
end

juju_port "80" do
  action :open
end