# frozen_string_literal: true

require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  setup do
    @app_key = application_keys(:one)
  end

  test 'should return false when promo does not apply' do
    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
                         return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 1)

    result = promo.evaluate_applicability({ total: 9, quantity: 0 }, @app_key)

    assert_not result[:error]
    assert_not result[:applicable]
  end

  test 'should return true when promo applies' do
    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
                            return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 1)

    result = promo.evaluate_applicability({ total: 11, quantity: 0, transaction_id: 4 }, @app_key)

    assert_not result[:error]
    assert result[:applicable]
    assert_equal :percentaje, result[:return_type].to_sym
    assert_equal 10, result[:return_value]
  end

  test 'should return false when wrong arguments given' do
    promo = Discount.new(code: 'code', name: 'a promotion', return_type: :percentaje,
                         return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 2)

    result = promo.evaluate_applicability({ amount: 15, tax: 3 }, @app_key)
    assert result[:error]
  end

  test 'should retourn error if transaction id was already used' do
    promo = Discount.create(code: 'code', name: 'a promotion', return_type: :percentaje,
                            return_value: 10, active: true, condition: 'total <= 100 AND quantity >= 5 OR total > 10', organization_id: 1)

    result = promo.evaluate_applicability({ total: 11, quantity: 0, transaction_id: 4 }, @app_key)

    assert_not result[:error]

    result = promo.evaluate_applicability({ total: 11, quantity: 0, transaction_id: 4 }, @app_key)

    assert result[:error]
  end
end
