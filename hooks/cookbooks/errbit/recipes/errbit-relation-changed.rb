

new_token = relation_get['secret-token']

unless new_token.nil?
 
if File.exist?('$CHARM_DIR/.secret_token')
	ruby_block "Check if Secret Token is present" do
		block do
		  juju-log("Sending my secret key as a candidate")		  
		  contents = File.open("$CHARM_DIR/.secret_token").read
		  
		  relation_set do
		    relation_id 'secret-token' = contents

		  File.open('/home/errbit/errbit/config/initializers/secret_token.rb', 'w') do |f2|
			  f2.puts contents
		  end

		end
	end
end


