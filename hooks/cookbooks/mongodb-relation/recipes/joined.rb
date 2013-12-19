
directory "$CHARM_DIR/mongo-data" do
	action :delete
end

execute "mongodump" do
  command "mongodump -h localhost -d errbit -o $CHARM_DIR/mongo-data"
end


