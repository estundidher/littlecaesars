json.array!(@places) do |place|
  json.extract! places, :id, :name, :code, :address, :phone, :description, :map
  json.url admin_place_url(place, format: :json)
end