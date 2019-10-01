# frozen_string_literal: true

class CreateCouponUsages < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_usages do |t|
      t.string :coupon_code
      t.references :promotion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
