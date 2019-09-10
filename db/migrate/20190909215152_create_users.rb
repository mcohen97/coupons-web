class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surename
      t.string :email
      t.string :organization

      t.timestamps
    end
  end
end
