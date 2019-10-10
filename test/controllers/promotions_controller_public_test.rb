# frozen_string_literal: true

require 'test_helper'

class PromotionsControllerPublicTest < ActionDispatch::IntegrationTest

  setup do
    @appkey = application_keys(:one)
    get '/users/sign_in'
    sign_in user
    post user_session_url
  end

  test "should generate report correctly " do
    get generate_report_url(promotions(:coupon1)), headers: {Authorization: @appkey.generate_token }
    assert_response :success
    report = @controller.instance_variable_get(:@report)
    assert_equal 7, report.invocations_count
    assert_equal 4, report.negetive_responses
    assert_equal  3/7, report.positive_ratio
    assert_equal 4/7, report.negative_ratio
    assert_equal 48, report.total_spent
  end

  test "should evaluate promotion correctly" do
    puts @appkey.promotions.count
    post evaluate_promotion_url, params: {	code: "COMIDADESC5",
      attributes: {total: "12", products_size: 2, transaction_id:6}
      }, 
      headers: {Authorization: @appkey.generate_token, Content_Type: 'application/json' }
    assert_response :success
  end
end
=begin
  #CANT BUILD FIXTURES IN ORDER TO HAVE APPLICATION KEYS HAVE PROMOTIONS (MANY TO MANY RELATIONSHIP)

  test "should evaluate promotion correctly" do
    puts @appkey.promotions.count
    post evaluate_promotion_url, params: {	code: "COMIDADESC5",
      attributes: {total: "12", products_size: 2, transaction_id:6}
      }, 
      headers: {Authorization: @appkey.generate_token, Content_Type: 'application/json' }
    assert_response :success
  end
  
end
=end