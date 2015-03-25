json.array!(@orders) do |order|
  json.extract! order, :id, :code, :price, :state, :created_at
  json.url admin_order_url(order, format: :json)
end