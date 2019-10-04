# frozen_string_literal: true

class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :code
      t.string :name
      t.boolean :active

      t.timestamps
    end
    add_index :promotions, :code, unique: true
  end
end
