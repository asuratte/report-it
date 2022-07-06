require "test_helper"

class ReportsByUserControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "admin and official users should get reports-by-user" do
    sign_in @official_user
    get reports_by_user_url, params: { user_id: @resident_user.id }
    assert_response :success
    sign_out @official_user
    sign_in @admin_user
    get reports_by_user_url, params: { user_id: @resident_user.id }
    assert_response :success
  end

  test "resident and unauthenticated users should not get reports-by-user" do
    get reports_by_user_url, params: { user_id: @resident_user.id }
    assert_response :redirect
    sign_in @resident_user
    get reports_by_user_url, params: { user_id: @resident_user.id }
    assert_response :redirect
    sign_out @resident_user
  end

end
