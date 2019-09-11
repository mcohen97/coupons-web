class User < ApplicationRecord
  has_one_attached :avatar
  has_secure_password

  def organization_name
    Organization.find(organization_id).organization_name
  end

  validates :name, :surename, :email, :role, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :correct_document_mime_type
  private

  def correct_document_mime_type
    if avatar.attached? && !avatar.content_type.in?(%w(image/jpg image/gif image/jpeg image/png))
      # avatar.purge # delete the uploaded file
      errors.add(:document, 'Must be an image')
    end
  end
end
