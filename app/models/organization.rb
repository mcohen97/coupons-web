# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :organization_name, uniqueness: true, presence: true
end
