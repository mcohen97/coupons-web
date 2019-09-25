class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :surname, :email, :role, presence: true
  has_one_attached :avatar
  validate :correct_document_mime_type
  validates :organization_id, presence: {message: "invalid"}

  def organization=(org_name)
    if self.role == "administrator"
      @org = Organization.new :organization_name => org_name
      if @org.save
        self.update_attribute(:organization_id, @org.id)
      end
    else
      @org = Organization.find_by organization_name: org_name
      self.update_attribute(:organization_id, @org.id)
    end
    @organization = org_name
  end

  def organization
    @organization
  end

  private

  def correct_document_mime_type
    if avatar.attached? && !avatar.content_type.in?(%w(image/jpg image/gif image/jpeg image/png))
      # avatar.purge # delete the uploaded file
      errors.add(:document, 'Must be an image')
    end
  end

end
