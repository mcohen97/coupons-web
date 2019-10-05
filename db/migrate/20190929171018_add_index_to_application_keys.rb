# frozen_string_literal: true

class AddIndexToApplicationKeys < ActiveRecord::Migration[6.0]
  def change
    add_index :application_keys, :name
  end
end
