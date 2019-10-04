# frozen_string_literal: true

class AddInheritanceToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :type, :string, null: false
  end
end
