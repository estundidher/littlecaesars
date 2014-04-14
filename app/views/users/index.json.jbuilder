json.array!(@users) do |user|
  json.extract! users, :id, :name
  json.url user_url(user, format: :json)
end