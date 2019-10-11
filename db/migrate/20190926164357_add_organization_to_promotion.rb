# frozen_string_literal: true

class AddOrganizationToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_reference :promotions, :organization, null: false, foreign_key: true
  end
end
