# frozen_string_literal: true

class AddNameToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :name, :string
  end
end
