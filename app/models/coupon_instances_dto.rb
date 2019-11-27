# frozen_string_literal: true

require 'securerandom'

class CouponInstancesDto
  include ActiveModel::Model

  attr_accessor :coupon_code, :quantity, :expiration, :max_uses, :promotion_id

  def initialize(args = {})
    @coupon_code = args['coupon_code']
    @quantity = args['quantity']
    @expiration = args['expiration']
    @max_uses = args['max_uses']
    @promotion_id = args['promotion_id'].to_i
  end

  def to_simple_date(date)
    return nil unless date
    t = DateTime.parse(date)
    t.strftime("%m/%d/%Y")
  end

  def percentage?
    @return_type == 'percentage'
  end

  def persisted?
    return false
  end

end
