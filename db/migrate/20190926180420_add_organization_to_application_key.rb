# frozen_string_literal: true

class AddOrganizationToApplicationKey < ActiveRecord::Migration[6.0]
  def change
    add_reference :application_keys, :organization, null: false, foreign_key: true
  end
end
