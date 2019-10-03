# frozen_string_literal: true

require 'parser.rb'

class Coupon < Promotion
  has_many :coupon_usages

  def apply_promo(arguments)
    coupon = CouponUsage.new(promotion_id: id, coupon_code: arguments[:coupon_code])
    coupon.save!
  end
end
