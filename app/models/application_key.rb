class ApplicationKey < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
