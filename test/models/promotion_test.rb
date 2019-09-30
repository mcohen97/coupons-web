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
      promo = Discount.create(code: 'code', name: 'a promotion', return_type: :credits,
        return_value: 10, active: true, condition: 'quantity > 3')
    end
  end

  test 'should not save promotion with percentaje over 100' do
    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 113, active: true, condition: 'quantity > 3')
    assert_not promo.save
    assert promo.errors[:return_value].any?
  end

  # Common condition-related behaviour between the different types of promotions is tested here.

  test 'should not save promotion with empty condition' do

    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true)
    
    assert_not promo.save
    assert promo.errors[:condition].any?
  end

  test 'should format correct condition' do

    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 1)
    
    assert promo.save
    assert_equal '( ( total <= 100 ) AND ( quantity >= 5 ) ) OR ( total > 10 )', promo.condition
  end

  test 'should not save promotion with invalid expresion' do
    # promotion with invalid condition expresion
    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total >')

    assert_not promo.save
    assert promo.errors[:condition].any?
  end
  
  test 'should not validate inactive promotions' do
    app_key = application_keys(:one)

    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: false, condition: 'quantity > 3')
      
    result = promo.evaluate_applicability({quantity:10, transaction_id: 4},app_key)

    assert_not result[:error]
    assert_not result[:applicable]
    assert_equal 'Promotion does not apply', result[:message]
    
  end

  test 'should return invalid for deleted promotions' do
    app_key = application_keys(:one)

    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
      return_value: 10, active: true, condition: 'quantity > 3', deleted: true)
      
    result = promo.evaluate_applicability({quantity:10, transaction_id: 4},app_key)

    assert_not result[:error]
    assert_not result[:applicable]
    assert_equal 'Promotion does not apply', result[:message]
  end

  test 'should return invalid for promotions from other organization' do
    app_key = application_keys(:one)

    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
    return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 2)

    result = promo.evaluate_applicability({quantity:10, transaction_id: 4},app_key)#org id = 1 (different)

    assert result[:error]
  end

  test 'should generate correct promotion report' do
    app_key = application_keys(:one)
    coupon1 = Promotion.find(1)

    first_report = coupon1.generate_report()

    assert_equal 0, first_report[:invocations_count]
    assert_equal 0, first_report[:positive_ratio]
    assert_equal 0, first_report[:negative_ratio]
    assert_equal 0, first_report[:average_response_time]
    assert_equal 0, first_report[:total_money_spent]

    coupon1.evaluate_applicability({total:200, products_size: 3, coupon_code: 6},app_key)
    coupon1.evaluate_applicability({total:153, products_size: 3, coupon_code: 6},app_key)
    coupon1.evaluate_applicability({total:300, products_size: 3, coupon_code: 5},app_key)

    second_report = coupon1.generate_report()

    assert_equal 3, second_report[:invocations_count]
    assert_equal 2.0/3, second_report[:positive_ratio]
    assert_equal 1.0/3, second_report[:negative_ratio]
    assert_equal 50, second_report[:total_money_spent]
  end

  test 'should apply filters specified in scope' do
    not_deleted_count = Promotion.not_deleted.count

    assert_equal 5, not_deleted_count
    
    refined_by_type_count = Promotion.not_deleted.by_type('Discount').count

    assert_equal 2, refined_by_type_count

    refined_by_status_count = Promotion.not_deleted.by_type('Discount').active?(true).count

    assert_equal 1, refined_by_status_count

    refined_by_code_count = Promotion.not_deleted.by_type('Discount').active?(true).by_code('CLA').count

    assert_equal 1, refined_by_code_count

    refined_by_name_count = Promotion.not_deleted.by_type('Discount').active?(true).by_code('CLA').by_name('Pizza').count

    assert_equal 0, refined_by_name_count

    similar_code_count = Promotion.by_code('MOCHI').count

    assert_equal 2, similar_code_count
  end

end
