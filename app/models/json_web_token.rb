# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = ENV["SECRET"]

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    puts token
    puts SECRET_KEY 
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
