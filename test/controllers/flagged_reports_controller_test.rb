require "test_helper"

class FlaggedReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "admin user should get flagged-reports" do
    sign_in @admin_user
    get flagged_reports_url
    assert_response :success
  end

  test "official and resident users should not get flagged-reports" do
    sign_in @official_user
    get flagged_reports_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get flagged_reports_url
    assert_response :redirect
  end

end
