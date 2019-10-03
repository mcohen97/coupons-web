# frozen_string_literal: true

class CreateCouponInstances < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_instances do |t|
      t.string :coupon_code
      t.references :promotion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
