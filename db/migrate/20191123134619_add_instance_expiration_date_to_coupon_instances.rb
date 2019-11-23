class AddInstanceExpirationDateToCouponInstances < ActiveRecord::Migration[6.0]
  def change
    add_column :coupon_instances, :instance_expiration_date, :datetime
  end
end
