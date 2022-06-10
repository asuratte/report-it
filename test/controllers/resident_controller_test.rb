require "test_helper"

class ResidentControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:one)
  end

  test "should get index" do
    sign_in @user
    get resident_path
    assert_response :success
  end
end
