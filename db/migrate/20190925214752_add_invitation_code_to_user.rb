class AddInvitationCodeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :invitation_code, :text
  end
end
