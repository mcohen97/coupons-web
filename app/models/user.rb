class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :organization_id, presence: {message: "invalid"}

  def organization=(org_name)
    @org = Organization.new :organization_name => org_name
    if @org.save
      self.update_attribute(:organization_id, @org.id)
    end
  end

  def organization
    @organization
  end

end
