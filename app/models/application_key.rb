# frozen_string_literal: true

class ApplicationKey < ApplicationRecord
  belongs_to :organization

  SECRET_KEY = Rails.application.config.jwt_secret

  acts_as_tenant(:organization)
  validates :name, presence: true, uniqueness: true

  def generate_token
    payload = {
      name: name
    }

    JsonWebToken.encode(payload)
  end

  def self.get_from_token_if_valid(token)
    payload = JsonWebToken.decode(token)
    @few = payload[:name]
    ApplicationKey.find_by_name(payload[:name])
  rescue StandardError => e
    NIL
  end
end
