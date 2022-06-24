require "test_helper"

class DeactivatedReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @deactivated_report_1 = reports(:two)
    @deactivated_report_2 = reports(:three)
    @deactivated_report_3 = reports(:four)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "admin user should get deactivated-reports" do
    sign_in @admin_user
    get deactivated_reports_url
    assert_response :success
  end

  test "official and resident users should not get deactivated-reports" do
    sign_in @official_user
    get deactivated_reports_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get deactivated_reports_url
    assert_response :redirect
  end

end
