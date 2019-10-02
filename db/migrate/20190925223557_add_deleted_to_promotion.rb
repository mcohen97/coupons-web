class AddDeletedToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :deleted, :boolean, null: false, default: false
  end
end
