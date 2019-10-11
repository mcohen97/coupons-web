# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum available_role: %i[administrator org_user]

  validates :role, presence: true, inclusion: { in: available_roles.keys }
  validates :name, presence: true, allow_blank: false
  validates :surname, presence: true, allow_blank: false
  validates :email, presence: true, allow_blank: false
  has_one_attached :avatar
  validate :correct_document_mime_type
  validates :organization_id, presence: { message: 'invalid' }
  after_save :invalidate_cache

  attr_writer :organization

  attr_reader :organization

  def self.cached_find(id)
    Rails.cache.fetch([User.name, id]) { find(id) }
  end

  def self.serialize_from_session(key, salt)
    single_key = key.is_a?(Array) ? key.first : key
    user = Rails.cache.fetch([User.name, single_key]) do
      User.where(id: single_key).entries.first
    end
    # validate user against stored salt in the session
    return user if user && user.authenticatable_salt == salt

    # fallback to devise default method if user is blank or invalid
    super
  end

  private

  def correct_document_mime_type
    if avatar.attached? && !avatar.content_type.in?(%w[image/jpg image/gif image/jpeg image/png])
      # avatar.purge # delete the uploaded file
      errors.add(:document, 'Must be an image')
    end
  end

  def invalidate_cache
    Rails.cache.delete("user:#{id}")
  end
end
