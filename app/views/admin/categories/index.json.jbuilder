json.array!(@categories) do |category|
  json.extract! categories, :id, :name
  json.url category_url(category, format: :json)
end