class CouponUsage < ApplicationRecord
  belongs_to :promotion
  validates :coupon_code, presence: true
  validates_uniqueness_of :coupon_code
end