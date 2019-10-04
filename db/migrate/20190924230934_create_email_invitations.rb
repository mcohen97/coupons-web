# frozen_string_literal: true

class CreateEmailInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :email_invitations, &:timestamps
  end
end
