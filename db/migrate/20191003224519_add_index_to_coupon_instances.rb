# frozen_string_literal: true

class AddIndexToCouponInstances < ActiveRecord::Migration[6.0]
  def change
    add_index :coupon_instances, %i[promotion_id coupon_code], unique: true
  end
end
