# frozen_string_literal: true

class AddConditionToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :condition, :string, null: false
  end
end
