require 'test_helper'

class PromotionTest < ActiveSupport::TestCase

  test 'should create promotion with the specified data' do
    promo = Promotion.new(code: 'code',
                          name: 'a promotion',
                          type: Promotion.coupon,
                          returnType: Promotion.percentaje,
                          returnValue: 10,
                          active: true)
    assert_equal(Promotion.coupon, promo.type)
    assert_equal(Promotion.percentaje, promo.returnType)
  end

  test 'should not save promotion with empty name' do
    promo = Promotion.new(code: 'code',
                          type: Promotion.coupon,
                          returnType: Promotion.percentaje,
                          returnValue: 10,
                          active: true)
    assert_not(promo.save)
  end

  test 'should not save promotion with empty code' do
    promo = Promotion.new(name: 'a promotion',
                          type: Promotion.coupon,
                          returnType: Promotion.percentaje,
                          returnValue: 10,
                          active: true)
    assert_not(promo.save)
  end
end
