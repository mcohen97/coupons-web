json.extract! user, :id, :name, :surename, :email, :organization, :created_at, :updated_at
json.url user_url(user, format: :json)
