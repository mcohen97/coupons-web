# frozen_string_literal: true

require 'test_helper'

class PromotionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    do_login users(:one)
  end

  test "should get promotions index" do
    get promotions_url
    assert_response :success
  end

  test "should get only promotions of current user's organization" do
    get promotions_url
    # only two promotions for organization 1
    assert_equal 2, @controller.instance_variable_get(:@promotions).count
  end

  test "should not include deleted promotions in index" do
    do_login users(:two)
    get promotions_url

    # one of the 4 promos of organizations 2 is deleted, so 3 should be shown
    assert_equal 3, @controller.instance_variable_get(:@promotions).count
  end

  test "should apply filters correctly" do
    do_login users(:two)
    get promotions_url, params: { code: 'mOchi'}
    
    # MOCHIUY and MOCHIX3
    assert_equal 2, @controller.instance_variable_get(:@promotions).count
    
    # MOCHIX3
    get promotions_url, params: { code: 'mOchi', name: 'ComprANDO 3 UNIDADES'}
    assert_equal 1, @controller.instance_variable_get(:@promotions).count

    # none
    get promotions_url, params: { code: 'mOchi', name: 'ComprANDO 3 UNIDADES', type: 'Coupon'}
    assert_equal 0, @controller.instance_variable_get(:@promotions).count

    # none
    get promotions_url, params: { code: 'mOchi', name: 'ComprANDO 3 UNIDADES', type: 'Discount', active: true}
    assert_equal 0, @controller.instance_variable_get(:@promotions).count

    # MOCHIX3
    get promotions_url, params: { code: 'mOchi', name: 'ComprANDO 3 UNIDADES', type: 'Discount', active: false}
    assert_equal 1, @controller.instance_variable_get(:@promotions).count
  end

  test "should get discount correctly" do
    get promotion_url(promotions(:discount1))
    promo = @controller.instance_variable_get(:@promotion)

    assert_equal 4, promo.id
    assert_equal 'Descuento comienzo clases', promo.name
    assert_equal 'CLASES', promo.code
    assert_equal 1, promo.organization_id
    assert_equal 'fixed_value', promo.return_type
    assert_equal 100, promo.return_value
    assert promo.active
    assert_equal 'Discount', promo.type
    assert_equal '(total <= 1000 AND quantity >= 5) OR total > 1000', promo.condition  
  end

  test "should get coupon correctly" do
    get promotion_url(promotions(:coupon1))
    coupon = @controller.instance_variable_get(:@promotion)
    coupon_instances = @controller.instance_variable_get(:@coupon_instances)

    assert_equal 1, coupon.id
    assert_equal 'Promo verano', coupon.name
    assert_equal 'COMIDADESC5', coupon.code
    assert_equal 1, coupon.organization_id
    assert_equal 'percentaje', coupon.return_type
    assert_equal 10, coupon.return_value
    assert coupon.active
    assert_equal 'Coupon', coupon.type
    assert_equal 'total > 100 AND products_size >= 2', coupon.condition
    
    # associated coupon_codes
    assert_equal 2, coupon_instances.count
  end

  test "should handle non-existent promotions request" do
    get promotion_url(53)
    assert_response :not_found
  end

  test "should not permit access to deleted promos" do
    do_login users(:two)
    get promotion_url(promotions(:discount2))
    assert_response :not_found  
  end

  test "should not permit access to promos from another org" do
    get promotion_url(promotions(:coupon2))
    assert_response :not_found
  end

  test "should create promotion with correct data" do
    assert_difference('Promotion.count') do
      post promotions_url, params: { 
        promotion: 
      { name: 'Spending more than 100 in coffee or buying 3 packs, you get 50% OFF',
       code: 'COFEE_DISCOUNT', 
       organization_id: 2, 
       return_type: 'percentaje',
       return_value: 50, 
       active: true,
       type: 'Coupon',
       condition: 'quantity = 3 OR total > 100' } 
       }
       
    end
    assert_redirected_to promotions_url
    assert_equal 'Promotion was successfully created.', flash[:notice]
  end

  test "should not allow non-administrator to create promotions" do
    do_login(users(:three))

    assert_no_difference('Promotion.count') do
      post promotions_url, params: { 
        promotion: 
      { name: 'Spending more than 100 in coffee or buying 3 packs, you get 50% OFF',
       code: 'COFEE_DISCOUNT', 
       organization_id: 2, 
       return_type: 'percentaje',
       return_value: 50, 
       active: true,
       type: 'Coupon',
       condition: 'quantity = 3 OR total > 100' } 
       }
       
    end
    assert_response :forbidden
  end

  test "should not create promotion with empty fields" do

    promo_params = { name: '', code: 'COFEE_DISCOUNT', organization_id: 2, 
     return_type: 'percentaje', return_value: 50, active: true, type: 'Coupon', condition: 'quantity = 3 OR total > 100' } 
    
    # perform a post for each parameter, with that parameter missing
    promo_params.keys.each { |key|
      assert_no_difference('Promotion.count') do
          post_params = promo_params.except(key)
          post promotions_url, params: { 
            promotion: post_params
           } 
        end
      assert_response :unprocessable_entity
      #puts "#{key} #{@controller.instance_variable_get(:@promotion).errors[key].any?}"
     }
  end

  test "should not create promotion with negative return value" do
    assert_no_difference('Promotion.count') do
      post promotions_url, params: { 
        promotion: { name: '', code: 'COFEE_DISCOUNT', organization_id: 2, 
          return_type: 'percentaje', return_value: -3, active: true, type: 'Coupon', condition: 'quantity = 3 OR total > 100' } 
       } 
    end
    assert_response :unprocessable_entity
  end

  test "should not create percentaje promotion with return value over 100" do
    assert_no_difference('Promotion.count') do
      post promotions_url, params: { 
        promotion: { name: '', code: 'COFEE_DISCOUNT', organization_id: 2, 
          return_type: 'percentaje', return_value: 103, active: true, type: 'Coupon', condition: 'quantity = 3 OR total > 100' } 
       } 
    end
    assert_response :unprocessable_entity
  end

  test "should not create promotion with wrong condition" do
    assert_no_difference('Promotion.count') do
      post promotions_url, params: { 
        # lacks one operand
        promotion: { name: '', code: 'COFEE_DISCOUNT', organization_id: 2, 
          return_type: 'percentaje', return_value: 55, active: true, type: 'Coupon', condition: 'quantity = 3 OR total > 100 OR quantity = 2 AND total >' } 
       } 
    end
    assert_response :unprocessable_entity

    assert_no_difference('Promotion.count') do
      post promotions_url, params: { 
        # lacks operator
        promotion: { name: '', code: 'COFEE_DISCOUNT', organization_id: 2, 
          return_type: 'percentaje', return_value: 55, active: true, type: 'Coupon', condition: 'quantity total' } 
       } 
    end
    assert_response :unprocessable_entity

    assert_no_difference('Promotion.count') do
      post promotions_url, params: { 
        # wrong order
        promotion: { name: '', code: 'COFEE_DISCOUNT', organization_id: 2, 
          return_type: 'percentaje', return_value: 55, active: true, type: 'Coupon', condition: '= quantity 10' } 
       } 
    end
    assert_response :unprocessable_entity
  end


  def do_login(user)
    get '/users/sign_in'
    sign_in user
    post user_session_url
  end
end
