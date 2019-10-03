# frozen_string_literal: true

class AddInvitationCodeTokenToEmailInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :email_invitations, :invitation_code, :string
    add_index :email_invitations, :invitation_code, unique: true
  end
end
