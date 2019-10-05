# frozen_string_literal: true

class AddSurnameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :surname, :string
  end
end
