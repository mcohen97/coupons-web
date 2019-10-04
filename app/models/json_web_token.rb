# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = Rails.application.config.jwt_secret

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
