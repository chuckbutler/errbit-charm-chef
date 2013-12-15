
#declare configurable settings
repository = config_get['repository']
release = config_get['release']

errbit_id = `id errbit`

juju_log("Creating Errbit user if not found")
execute "adduser --disabled-password --gecos 'Errbit' errbit" do
	not_if errbit_id != ''
end

git "/home/errbit/errbit" do
	repository config_get['repository']
	reference config_get['release']
	action :sync
end

directory "/home/errbit/errbit" do
	owner "errbit"
	group "errbit"
	recursive true
end

execute "bundle install --no-ri --no-rdoc --without test --deployment" do
	cwd "/home/errbit/errbit"
	not_if 'bundle check'
end
