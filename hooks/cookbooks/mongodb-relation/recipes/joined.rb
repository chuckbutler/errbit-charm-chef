
directory "mnt/mongo-data" do
  action :delete
end

directory "/mnt/mongo-data" do
  action :create
end

execute "mongodump" do
  command "mongodump -h localhost -d errbit -o /mnt/mongo-data"
end


