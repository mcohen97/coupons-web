# frozen_string_literal: true

require 'securerandom'

class CouponInstancesDto
  include ActiveModel::Model

  attr_accessor :coupon_code, :quantity, :expiration, :max_uses

  def initialize(args = {})
    @coupon_code = args['promotion_name']
    @quantity = args['instances_count']
    @expiration = args['expiration_date']
    @max_uses = args['usage_count']
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
