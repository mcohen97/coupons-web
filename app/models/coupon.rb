# frozen_string_literal: true

require 'parser.rb'
require_relative '../../lib/error/promotion_arguments_error.rb'

class Coupon < Promotion
  has_many :coupon_instances

  def apply_promo(arguments)
    to_reedem = CouponInstance.find_by(promotion_id: id, coupon_code: arguments[:coupon_code])
    if to_reedem.nil?
      raise PromotionArgumentsError, 'Coupon code does not exist for this promotion'
    elsif to_reedem.redeemed
      raise PromotionArgumentsError, 'Coupon was already redeemed'
    else
      to_reedem.update(redeemed: true)
    end
  end
end
