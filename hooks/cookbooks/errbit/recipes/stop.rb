service 'errbit' do
	action :stop
end

juju_Port "port[80]" do
  action :close
end
