# frozen_string_literal: true

class CouponInstance < ApplicationRecord
  belongs_to :promotion
  validates :coupon_code, presence: true
  validates_uniqueness_of :coupon_code
end
