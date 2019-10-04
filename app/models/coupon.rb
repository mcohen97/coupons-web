# frozen_string_literal: true

require 'parser.rb'
require_relative '../../lib/error/promotion_arguments_error.rb'

class Coupon < Promotion
  has_many :coupon_instances

  def apply_promo(arguments)
    to_reedem = CouponInstance.find_by(promotion_id: id, coupon_code: arguments[:coupon_code])
    if to_reedem.nil?
      add_negative_response
      raise PromotionArgumentsError, 'Coupon code does not exist for this promotion'
    elsif to_reedem.redeemed
      add_negative_response
      raise PromotionArgumentsError, 'Coupon was already redeemed'
    else
      to_reedem.update(redeemed: true)
    end
  end

  def generate_coupon_instances(count)

    ActiveRecord::Base.transaction do
      i = 0  
      while i < count do
        CouponInstance.new(promotion_id: id, coupon_code: "#{code}_#{SecureRandom.uuid[0, 5]}").save
        i += 1
      end
    end

  end

end
