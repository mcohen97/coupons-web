class AddReturnToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :return_type, :integer, default: 0
    add_column :promotions, :return_value, :integer
  end
end
