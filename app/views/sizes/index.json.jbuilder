json.array!(@sizes) do |size|
  json.extract! sizes, :id, :name
  json.url size_url(size, format: :json)
end