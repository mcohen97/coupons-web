require 'test_helper'


class CouponTest < ActiveSupport::TestCase
  test "should return false when promo does not apply" do
    promo = Coupon.create(organization_id: 1, code: 'code4', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2')
    
    result = promo.evaluate_applicability({total:9, products_size:3})
    assert_not result[:error]
    assert_not result[:applicable]
   end

   test "should return true when promo applies" do
    promo = Coupon.create(code: 'code5', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: 2)
    
    result = promo.evaluate_applicability({total:101, products_size:3, coupon_code: 5})

    assert_not result[:error]
    assert result[:applicable]
    assert_equal :percentaje, result[:return_type].to_sym
    assert_equal 10, result[:return_value]
   end

   test "should return false when wrong arguments given" do
    promo = Coupon.new(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 1)
    
    result = promo.evaluate_applicability({amount:15, tax:3})
    assert result[:error]
   end

   test "should retourn error if coupon code was used" do
     
    promo = Coupon.create(code: 'code5', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: 2)
      
    result = promo.evaluate_applicability({total:101, products_size:3, coupon_code: 6})
  
    assert_not result[:error]
    
    result = promo.evaluate_applicability({total:101, products_size:3, coupon_code: 6})

    assert result[:error]
   end

   test 'should return error if coupon_code was not provided' do
    promo = Coupon.create(code: 'code5', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2')
      
    result = promo.evaluate_applicability({total:101, products_size:3})
  
    assert result[:error]
    
   end

end
