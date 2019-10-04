# frozen_string_literal: true

class AddUserToEmailInvitation < ActiveRecord::Migration[6.0]
  def change
    add_reference :email_invitations, :user, null: false, foreign_key: true
  end
end
