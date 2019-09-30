class CreateEmailInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :email_invitations do |t|

      t.timestamps
    end
  end
end
