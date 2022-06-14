require "test_helper"

class OfficialControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @user = users(:one)
  end

  test "should get official index" do
    get '/users/sign_in'
    sign_in users(:two)
    get official_url
    assert_response :success
  end

  test "should get admin index" do
    get '/users/sign_in'
    sign_in users(:three)
    get official_url
    assert_response :success
  end
end
