require 'test_helper'

class PromotionTest < ActiveSupport::TestCase

  test 'should create promotion with the specified data' do
    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'quantity > 3')
    assert_equal(:Discount, promo.type.to_sym)
    assert_equal(:percentaje, promo.return_type.to_sym)
    assert promo.active
    assert_equal('code', promo.code)
    assert_equal('a promotion', promo.name)
    assert_equal('quantity > 3', promo.condition)
  end

  test 'should not save promotion with empty name' do   
    promo = Discount.new(code: 'code', return_type: :percentaje,
      return_value: 10, active: true, condition: 'quantity > 3')
    assert_not promo.save
    assert promo.errors[:name].any?
  end

  test 'should not save promotion with empty code' do
    promo = Coupon.new(name: 'a promotion',return_type: :percentaje,
                          return_value: 10, active: true, condition: 'quantity > 3')
    assert_not promo.save
    assert promo.errors[:code].any?
  end

  test 'should not save promotion with zero or negative return value' do
    promo1 = Coupon.new(name: 'a promotion',return_type: :percentaje, active: true, condition: 'quantity > 3')
    assert_not promo1.save
    assert promo1.errors[:return_value].any?

    promo2 = Coupon.new(name: 'a promotion', return_value: -5 ,return_type: :percentaje, active: true, condition: 'quantity > 3')
    assert_not promo2.save
    assert promo2.errors[:return_value].any?
  end

  test 'should not save promotion with undefined return type' do
    assert_raises(ArgumentError) do
      promo = Discount.new(code: 'code', name: 'a promotion', return_type: :credits,
        return_value: 10, active: true, condition: 'quantity > 3')
    end
  end

  # Common condition-related behaviour between the different types of promotions is tested here.

  test 'should not save promotion with empty condition' do

    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true)
    
    assert_not promo.save
    assert promo.errors[:condition].any?
  end

  test 'should format correct condition' do

    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10')
    
    assert promo.save
    assert_equal '( ( total <= 100 ) AND ( quantity >= 5 ) ) OR ( total > 10 )', promo.condition
  end

  test 'should not save promotion with invalid expresion' do
    # promotion with invalid condition expresion
    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total >')

    assert_not promo.save
    assert promo.errors[:condition].any?
  end
  
end
