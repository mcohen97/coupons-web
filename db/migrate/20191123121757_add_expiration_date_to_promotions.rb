class AddExpirationDateToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :expiration_date, :datetime
  end
end
