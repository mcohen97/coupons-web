class ApplicationKey < ApplicationRecord
  acts_as_tenant(:organization)

  validates :name, presence: true, uniqueness: true
end
