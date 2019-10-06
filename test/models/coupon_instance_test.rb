# frozen_string_literal: true

require 'test_helper'

class CouponInstanceTest < ActiveSupport::TestCase
  
  test "should create instance with the specified data" do
    instance = CouponInstance.new(promotion_id: 1, coupon_code: 'coupon1-1')
    assert instance.save
    assert_equal(1, instance.promotion_id)
    assert_equal('coupon1-1', instance.coupon_code)
  end

  test "should not create coupon instance with empty code" do
    instance = CouponInstance.new(promotion_id: 1, coupon_code: '')
    assert_not instance.save
    assert instance.errors[:coupon_code].any?
  end

  test "promotion id should reference a Coupon" do
    instance = CouponInstance.new(promotion_id: 4, coupon_code: 'coupon1-1')
    assert_not instance.save
    assert instance.errors[:base].any?
  end
  
  test "should create instance with repeated data" do
    instance = CouponInstance.new(promotion_id: 1, coupon_code: 'coupon1-1')
    assert instance.save
    instance = CouponInstance.new(promotion_id: 1, coupon_code: 'coupon1-1')
    assert_not instance.save
  end
end
