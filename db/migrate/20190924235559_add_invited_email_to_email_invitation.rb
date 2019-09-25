class AddInvitedEmailToEmailInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :email_invitations, :invited_email, :text
  end
end
