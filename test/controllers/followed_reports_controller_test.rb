require "test_helper"

class FollowedReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @followed_report = followed_reports(:one)
  end

  test "should get index" do
    get followed_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_followed_report_url
    assert_response :success
  end

  test "should create followed_report" do
    assert_difference('FollowedReport.count') do
      post followed_reports_url, params: { followed_report: { report_id: @followed_report.report_id, user_id: @followed_report.user_id } }
    end

    assert_redirected_to followed_report_url(FollowedReport.last)
  end

  test "should show followed_report" do
    get followed_report_url(@followed_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_followed_report_url(@followed_report)
    assert_response :success
  end

  test "should update followed_report" do
    patch followed_report_url(@followed_report), params: { followed_report: { report_id: @followed_report.report_id, user_id: @followed_report.user_id } }
    assert_redirected_to followed_report_url(@followed_report)
  end

  test "should destroy followed_report" do
    assert_difference('FollowedReport.count', -1) do
      delete followed_report_url(@followed_report)
    end

    assert_redirected_to followed_reports_url
  end
end
