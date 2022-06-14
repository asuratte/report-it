require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @user = users(:one)
  end

  test "should get index" do
    get reports_url
    assert_response :success
  end

  test "should not get new if signed out" do
    get new_report_url
    assert_response :redirect
  end

  test "should not get new without categories if signed in" do
    sign_in @user
    get new_report_url
    assert_response :redirect
  end

  test "should get new without categories if signed in" do
    sign_in @user
    get new_report_path(category: "Animals", subcategory: "Nuisance animal complaint")
    assert_response :success
  end

  test "should create report if signed in" do
    sign_in @user
    assert_difference('Report.count') do
      post reports_url, params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, severity: @report.severity, state: @report.state, status: @report.status, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip } }
    end

    assert_redirected_to resident_path
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
  end

  test "should get edit" do
    get '/users/sign_in'
    sign_in users(:two)
    get edit_report_url(@report)
    assert_response :success
  end

  test "should update report" do
    get '/users/sign_in'
    sign_in users(:two)
    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, severity: @report.severity, state: @report.state, status: @report.status, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip } }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    get '/users/sign_in'
    sign_in users(:two)
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
end
