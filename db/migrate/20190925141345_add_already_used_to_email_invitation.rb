# frozen_string_literal: true

class AddAlreadyUsedToEmailInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :email_invitations, :already_used, :boolean, default: FALSE
  end
end
