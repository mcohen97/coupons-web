class AddOrganizationToEmailInvitation < ActiveRecord::Migration[6.0]
  def change
    add_reference :email_invitations, :organization, null: false, foreign_key: true
  end
end
