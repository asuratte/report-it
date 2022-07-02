require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = users(:three)
  end

  test "admin should go to homepage on login" do
    sign_in @admin_user
    post user_session_url
    assert_redirected_to root_path
  end
  
  test "should get index" do
    get root_url
    assert_response :success
  end
end
