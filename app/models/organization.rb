class Organization < ApplicationRecord
  validates :organization_name, uniqueness: true, presence: true
end
