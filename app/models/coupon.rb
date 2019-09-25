require 'parser.rb'

class Coupon < Promotion

  has_many :coupon_usages
  enum valid_arguments: %i[coupon_code total products_size]
  #enum mandatory_arguments: %i[coupon_code]

  def register_usage(arguments)
    coupon = CouponUsage.new(promotion_id: id, coupon_code: arguments[:coupon_code])
    coupon.save!
  end
end