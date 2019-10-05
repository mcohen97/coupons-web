# frozen_string_literal: true

class ApplicationKey < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :promotions
  validate :promotions_of_same_org

  SECRET_KEY = Rails.application.config.jwt_secret

  acts_as_tenant(:organization)
  validates :name, presence: true, uniqueness: true

  def generate_token
    payload = {
      name: name,
      promotions: promotion_ids
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

  def promotions_of_same_org
    promotions.each { |promo| 
      if promo.organization_id != organization_id
        errors.add(:promotions, "promotion #{promo.code} is from another organization")
        break
      end
    }

  end
end
