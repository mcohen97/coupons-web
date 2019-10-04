class AddIndexToCouponInstances < ActiveRecord::Migration[6.0]
  def change
    add_index :coupon_instances, [:promotion_id, :coupon_code], unique: true
  end
end
