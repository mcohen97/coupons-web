# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :organization_name, uniqueness: true, presence: true

  def self.cached_find(id)
    Rails.cache.fetch([Organization.name, id]) { find(id) }
  end
end
