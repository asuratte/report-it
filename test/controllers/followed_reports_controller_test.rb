require "test_helper"

class FollowedReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
    @followed_report = followed_reports(:one)
  end

  test "resident user should get followed reports" do
    sign_in @resident_user
    get followed_reports_url
    assert_response :success
  end

  test "official, admin, and unauthenticated users should not get followed reports" do
    get followed_reports_url
    assert_response :redirect
    sign_in @official_user
    get followed_reports_url
    assert_response :redirect
    sign_out @official_user
    sign_in @admin_user
    get followed_reports_url
    assert_response :redirect
    sign_out @admin_user
  end

end
