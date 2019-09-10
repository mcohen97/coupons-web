class User < ApplicationRecord
  validates :name, :surename, :organization, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
