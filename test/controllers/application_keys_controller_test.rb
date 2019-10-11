# frozen_string_literal: true

require 'test_helper'
class ApplicationKeysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    do_login users(:one)
    @application_key = application_keys(:one)
  end

  test 'should get index' do
    get application_keys_url
    assert_response :success
  end

  test 'should not get index for non-administrator users' do
    do_login users(:three)
    get application_keys_url
    assert_response :forbidden
  end

  test 'should get only appkeys of users organization' do
    get application_keys_url
    assert_equal 2, @controller.instance_variable_get(:@application_keys).count
  end

  test 'should get only appkeys of users organization (different user)' do
    do_login(users(:two))

    get application_keys_url
    assert :success
    assert_equal 1, @controller.instance_variable_get(:@application_keys).count
  end

  test 'should get key for administrator' do
    get application_key_url(application_keys(:one))

    assert_response :success

    appkey = @controller.instance_variable_get(:@application_key)
    assert_equal 'AppKey1', appkey.name
    assert_equal users(:one).organization_id, appkey.organization_id
  end

  test 'should not allow access to key to non-administrator' do
    do_login users(:three)
    get application_key_url(application_keys(:one))
    assert_response :forbidden
  end

  test 'should not allow access to another organizations key' do
    get application_key_url(application_keys(:two))
    assert_response :not_found
  end

  test 'should handle show for non-existing keys' do
    get application_key_url(71)
    assert_response :not_found
  end

  test 'should get new' do
    get new_application_key_url
    assert_response :success
  end

  test 'should create application_key with correct data' do
    assert_difference('ApplicationKey.count') do
      post application_keys_url, params: { application_key: { name: 'AppKey', promotion_ids: [1, 4] } }
    end

    assert_redirected_to application_key_url(ApplicationKey.last)
    appkey = @controller.instance_variable_get(:@application_key)
    assert_equal 'AppKey', appkey.name
    assert_equal 2, appkey.promotions.count
  end

  test 'should not create application key with empty name' do
    assert_no_difference('ApplicationKey.count') do
      post application_keys_url, params: { application_key: { name: '' } }
    end
    assert_response :unprocessable_entity
    appkey = @controller.instance_variable_get(:@application_key)
    assert appkey.errors[:name].any?
  end

  test 'should not create application key with repeated name' do
    assert_no_difference('ApplicationKey.count') do
      post application_keys_url, params: { application_key: { name: 'AppKey1' } }
    end
    assert_response :unprocessable_entity
    appkey = @controller.instance_variable_get(:@application_key)
    assert appkey.errors[:name].any?
  end

  test 'should not create application key having promotions of another organization' do
    # not very clear behaviour, but understandable, the RecordNotFound exception must be raised because of multitenancy
    assert_no_difference('ApplicationKey.count') do
      post application_keys_url, params: { application_key: { name: 'AppKey', promotion_ids: [1, 2] } }
    end
    assert_response :not_found
  end

  test 'should not permit creation to non-administrator' do
    do_login users(:three)
    assert_no_difference('ApplicationKey.count') do
      post application_keys_url, params: { application_key: { name: 'AppKey' } }
    end
    assert_response :forbidden
  end

  test 'should get edit' do
    get edit_application_key_url(@application_key)
    assert_response :success
  end

  test 'should update application_key' do
    patch application_key_url(@application_key), params: { application_key: { name: 'AppKey' } }
    assert_redirected_to application_key_url(@application_key)
    appkey = @controller.instance_variable_get(:@application_key)
    assert_equal 'AppKey', appkey.name
  end

  test 'should not update application key with empty name' do
    patch application_key_url(@application_key), params: { application_key: { name: '' } }
    assert_response :unprocessable_entity
    appkey = @controller.instance_variable_get(:@application_key)
    assert appkey.errors[:name].any?
  end

  test 'should not update application key with repeated name' do
    patch application_key_url(@application_key), params: { application_key: { name: 'AppKey2' } }
    assert_response :unprocessable_entity
    appkey = @controller.instance_variable_get(:@application_key)
    assert appkey.errors[:name].any?
  end

  test 'should not permite update to promotion from another organization' do
    patch application_key_url(application_keys(:two)), params: { application_key: { name: 'AppKey' } }
    assert_response :not_found
  end

  test 'should not permit update to non-administrator' do
    do_login users(:three)
    patch application_key_url(@application_key), params: { application_key: { name: 'AppKey' } }
    assert_response :forbidden
  end

  test 'should destroy application_key' do
    assert_difference('ApplicationKey.count', -1) do
      delete application_key_url(@application_key)
    end

    assert_redirected_to application_keys_url
  end

  test 'should handle destruction of non-existing promotion' do
    assert_no_difference('ApplicationKey.count') do
      delete application_key_url(100)
    end
    assert_response :not_found
  end

  test 'should not permit non-administrator destroy promotion' do
    do_login users(:three)
    assert_no_difference('ApplicationKey.count') do
      delete application_key_url(@application_key)
    end
    assert_response :forbidden
  end

  def do_login(user)
    get '/users/sign_in'
    sign_in user
    post user_session_url
  end
end
