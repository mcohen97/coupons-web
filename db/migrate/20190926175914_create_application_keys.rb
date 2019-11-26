# frozen_string_literal: true

class CreateApplicationKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :application_keys do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
