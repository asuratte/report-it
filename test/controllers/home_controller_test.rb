require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = users(:three)
    @resident_user = users(:one)
    @official_user = users(:two)
  end

  test "admin should go to homepage on login" do
    sign_in @admin_user
    post user_session_url
    assert_redirected_to root_path
  end

  test "official should go to homepage on login" do
    sign_in @official_user
    post user_session_url
    assert_redirected_to root_path
  end

  test "resident should go to homepage on login" do
    sign_in @resident_user
    post user_session_url
    assert_redirected_to root_path
  end
  
  test "should get index" do
    get root_url
    assert_response :success
  end
end
