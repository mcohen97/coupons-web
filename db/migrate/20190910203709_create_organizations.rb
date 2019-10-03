# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations, &:timestamps
  end
end
