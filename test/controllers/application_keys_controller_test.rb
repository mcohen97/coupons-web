require 'test_helper'

class ApplicationKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_key = application_keys(:one)
  end

  test "should get index" do
    get application_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_application_key_url
    assert_response :success
  end

  test "should create application_key" do
    assert_difference('ApplicationKey.count') do
      post application_keys_url, params: { application_key: { name: @application_key.name } }
    end

    assert_redirected_to application_key_url(ApplicationKey.last)
  end

  test "should show application_key" do
    get application_key_url(@application_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_key_url(@application_key)
    assert_response :success
  end

  test "should update application_key" do
    patch application_key_url(@application_key), params: { application_key: { name: @application_key.name } }
    assert_redirected_to application_key_url(@application_key)
  end

  test "should destroy application_key" do
    assert_difference('ApplicationKey.count', -1) do
      delete application_key_url(@application_key)
    end

    assert_redirected_to application_keys_url
  end
end
