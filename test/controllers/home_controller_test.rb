# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    do_login users(:one)
  end

  test 'should get invitation view' do
    get invitation_url
    assert_response :success
  end

  test 'should send invitation mail' do
    # Asserts the difference in the ActionMailer::Base.deliveries
    assert_emails 1 do
      post invite_url, params: { email: 'friend@example.com' }
    end
    assert_redirected_to home_path
    assert_equal 'Email succesfully sent!', flash[:success]
  end

  test 'should not allow non-administrator access de invitation view' do
    do_login users(:three)
    get invitation_url
    assert_response :forbidden
  end

  test 'should not allow non-administrator invite' do
    do_login users(:three)
    assert_emails 0 do
      post invite_url, params: { email: 'friend@example.com' }
    end
    assert_response :forbidden
  end

  test 'should logout correctly' do
    delete destroy_user_session_url
    assert_redirected_to root_url
    get home_url
    assert_redirected_to new_user_session_url
  end

  def do_login(user)
    get '/users/sign_in'
    sign_in user
    post user_session_url
  end
end
