json.array!(@customers) do |customer|
  json.extract! customers, :id, :name
  json.url admin_customer_url(customer, format: :json)
end