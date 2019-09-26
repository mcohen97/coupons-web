class CreateDiscountUsages < ActiveRecord::Migration[6.0]
  def change
    create_table :discount_usages do |t|
      t.string :transaction_id
      t.references :promotion, null: false, foreign_key: true
      t.timestamps
    end
  end
end
