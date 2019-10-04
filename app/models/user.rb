# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :surname, :email, :role, presence: true, allow_blank: false
  has_one_attached :avatar
  validate :correct_document_mime_type
  validates :organization_id, presence: { message: 'invalid' }

  attr_writer :organization

  attr_reader :organization

  private

  def correct_document_mime_type
    if avatar.attached? && !avatar.content_type.in?(%w[image/jpg image/gif image/jpeg image/png])
      # avatar.purge # delete the uploaded file
      errors.add(:document, 'Must be an image')
    end
  end
end
