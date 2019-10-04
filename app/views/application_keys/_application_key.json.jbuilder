# frozen_string_literal: true

json.extract! application_key, :id, :name, :created_at, :updated_at
json.url application_key_url(application_key, format: :json)
