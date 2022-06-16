require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "should get index" do
    get reports_url
    assert_response :success
  end

  test "should get new with specified categories if signed in" do
    sign_in @resident_user
    get new_report_path(category: "Animals", subcategory: "Nuisance animal complaint")
    assert_response :success
  end

  test "should not get new without categories if signed in" do
    sign_in @resident_user
    get new_report_url
    assert_response :redirect
  end

  test "should not get new if signed out" do
    get new_report_url
    assert_response :redirect
  end

  test "should create report" do
    sign_in @resident_user
    assert_difference('Report.count') do
      post reports_url, params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, severity: @report.severity, state: @report.state, status: @report.status, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip } }
    end

    assert_redirected_to resident_path
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
  end

  test "should get edit if signed in as resident who created report" do
    sign_in @resident_user
    get edit_report_url(@report)
    assert_response :success
  end

  test "should not get edit if report status not new" do
    sign_in @resident_user
    get edit_report_url(reports(:three))
    assert_response :redirect
  end

  test "should get edit if signed in as official or admin" do
    sign_in @official_user
    get edit_report_url(@report)
    assert_response :success
    sign_out @official_user
    sign_in @admin_user
    get edit_report_url(@report)
    assert_response :success
  end

  test "should not get edit if signed in as resident who did not create report" do
    sign_in @resident_user
    get edit_report_url(reports(:two))
    assert_response :redirect
  end

  test "should not get edit if not signed in" do
    get edit_report_url(@report)
    assert_response :redirect
  end

  test "should update report" do
    sign_in @resident_user
    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, state: @report.state, status: @report.status, severity: @report.severity, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip } }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    sign_in @resident_user
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
  
end
