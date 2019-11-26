class AddExpirationDateToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :expiration, :datetime
  end
end
