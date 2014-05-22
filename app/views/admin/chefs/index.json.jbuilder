json.array!(@chefs) do |chef|
  json.extract! chefs, :id, :name, :address, :phone, :description, :map
  json.url admin_chef_url(chef, format: :json)
end