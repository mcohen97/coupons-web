require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  test "should return false when promo does not apply" do
    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10')
    
    result = promo.evaluate_applicability({total:9, quantity:0})
    assert_not result[:error]
    assert_not result[:applicable]
   end

   test "should return true when promo applies" do
    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10')
    
    result = promo.evaluate_applicability({total:11, quantity:0})
    assert_not result[:error]
    assert result[:applicable]
    assert_equal :percentaje, result[:return_type].to_sym
    assert_equal 10, result[:return_value]
   end

   test "should return false when wrong arguments given" do
    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10')
    
    result = promo.evaluate_applicability({amount:15, tax:3})
    assert result[:error]
   end
end
