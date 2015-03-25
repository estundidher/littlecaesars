json.array!(@users) do |user|
  json.extract! users, :id, :name
  json.url admin_user_url(user, format: :json)
end