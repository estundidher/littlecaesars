json.array!(@ingredients) do |ingredient|
  json.extract! ingredients, :id, :name
  json.url ingredient_url(ingredient, format: :json)
end