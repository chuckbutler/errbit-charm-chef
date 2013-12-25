module AssetHelper

	def recompile_assets
		if upgraded? 
			execute "recompile_assets" do
			    user "errbit"
			    cwd node[:errbit][:path]
			    command "bundle exec rake assets:clean && bundle exec rake assets:precompile"
			    environment ({'RAILS_ENV' => 'production'})
			    ignore_failure true
			    notifies :run, "execute[cache_git_revision]", :immediately
		  	end
		end
	end

	def upgraded?
		git = `cd #{node[:errbit][:path]} && git rev-parse HEAD`.chomp
		cached = `cat #{ENV['CHARM_DIR']}/errbit_revision`.chomp
		git != cached
	end
end
