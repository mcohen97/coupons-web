# frozen_string_literal: true

class ApplicationKey < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :promotions
  validate :promotions_of_same_org
  after_commit :flush_appkeys_cache

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
    key_name = payload[:name]
    app_key = Rails.cache.fetch([self.class.name, key_name]){ find_by_name(key_name) }
    Rails.cache.write([self.class.name, app_key.id], app_key)
    app_key
  rescue StandardError => e
    nil
  end

  def self.cached_find(id)
    Rails.cache.fetch([self.class.name, id]){ find(id) }
  end

  def promotions_of_same_org
    promotions.each { |promo| 
      if promo.organization_id != organization_id
        errors.add(:promotions, "promotion #{promo.code} is from another organization")
        break
      end
    }

  end

  private

  def flush_appkeys_cache
    Rails.cache.delete([self.class.name, name])
    Rails.cache.delete([self.class.name, id])
  end
end
