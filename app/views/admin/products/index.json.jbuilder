json.array!(@products) do |dish|
  json.extract! products, :id, :name
  json.url dish_url(product, format: :json)
end