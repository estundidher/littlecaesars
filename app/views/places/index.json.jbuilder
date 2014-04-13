json.array!(@places) do |place|
  json.extract! places, :id, :name, :address, :phone, :description, :map
  json.url place_url(place, format: :json)
end