# frozen_string_literal: true

require 'parser.rb'
require_relative '../../lib/error/promotion_arguments_error.rb'

class Coupon < Promotion

  MAX_COUPON_INSTANCES = 100
  DEFAULT_COUPON_INSTANCES = 5
  
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

  def generate_coupon_instances(count, instance_expiration_date)

    ActiveRecord::Base.transaction do
      instances = 1..count
      puts "creating #{count} instances"
      instances.each do
        puts instance_expiration_date
        CouponInstance.new(promotion_id: id, coupon_code: "#{code}_#{SecureRandom.uuid[0, 5]}", instance_expiration_date: instance_expiration_date).save
      end
    end

  end

end
