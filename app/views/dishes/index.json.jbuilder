json.array!(@dishes) do |dish|
  json.extract! dishes, :id, :name
  json.url dish_url(dish, format: :json)
end