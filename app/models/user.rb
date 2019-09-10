class User < ApplicationRecord
  validates :name, :surename, :organization, :email, :role, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}
end
