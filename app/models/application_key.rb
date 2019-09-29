class ApplicationKey < ApplicationRecord
  SECRET_KEY = Rails.application.config.jwt_secret

  acts_as_tenant(:organization)
  validates :name, presence: true, uniqueness: true

  def promotions
    Promotion.all
  end

  def generate_token
    payload = {
        name: name
    }

    JsonWebToken.encode(payload)
  end

  def self.get_from_token_if_valid(token)
    begin
      payload = JsonWebToken.decode(token)
      @few = payload[:name]
      return ApplicationKey.find_by_name(payload[:name])

    rescue StandardError => e
      return NIL
    end
  end

end
