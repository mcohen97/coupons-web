# frozen_string_literal: true

class CouponInstance < ApplicationRecord
  belongs_to :promotion
  validates :coupon_code, presence: true
  validates_uniqueness_of :coupon_code
  validate :belongs_to_coupon

  def belongs_to_coupon
    errors.add(:base, 'Must belong to coupon') if promotion.type != 'Coupon'
  end
end
