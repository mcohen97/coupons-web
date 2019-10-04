# frozen_string_literal: true

require 'test_helper'

class PromotionsControllerTest < ActionDispatch::IntegrationTest
  test 'should show only users organization promotions' do
    log_in_as users(:one)

    get promotions_url
    assert_select 'h2', 2

    delete destroy_user_session_url
    log_in_as users(:two)

    get promotions_url
    assert_select 'h2', 3
  end
end
