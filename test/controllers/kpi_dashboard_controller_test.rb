require "test_helper"

class KpiDashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "admin user should get kpi-dashboard" do
    sign_in @admin_user
    get kpi_dashboard_path
    assert_response :success
  end

  test "official, resident, and unauthenticated users should not get kpi-dashboard" do
    get kpi_dashboard_path
    assert_response :redirect
    sign_in @official_user
    get kpi_dashboard_path
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get kpi_dashboard_path
    assert_response :redirect
    sign_out @resident_user
  end

  test "should show charts on 'choose dates' button click when start and end date are provided and reports exist for range" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.beginning_of_day + 1.year).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".kpis-title", text: "KPIs for #{@start_date.to_date.to_s} - #{@end_date.to_date.to_s}"
  end

  test "should show charts on 'choose dates' button click when start and end date are equal and reports exist for range" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = DateTime.current.beginning_of_day.to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".kpis-title", text: "KPIs for #{@start_date.to_date.to_s}"
  end

  test "should show charts on 'view all time' button click when start and end date are provided and reports exist" do
    sign_in @admin_user
    get '/kpi-dashboard?start_date=&end_date=&commit=View+All+Time'
    assert_response :success
    assert_select ".kpis-title", text: "KPIs for All Time"
  end

  test "should not show charts upon visiting KPI dashboard without submitting dates" do
    sign_in @admin_user
    get kpi_dashboard_path
    assert_response :success
    assert_select ".total-submitted h2", false
  end

  test "should not show charts on 'choose dates' button click when both start and end date are not provided" do
    sign_in @admin_user
    @start_date = (DateTime.current.beginning_of_day + 1.month).to_s
    @end_date = (DateTime.current.beginning_of_day + 1.year).to_s
    get '/kpi-dashboard?start_date=&end_date=&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false
    assert_equal true, @controller.view_assigns['invalid_date']

    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false
    assert_equal true, @controller.view_assigns['invalid_date']

    get '/kpi-dashboard?start_date=&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false
    assert_equal true, @controller.view_assigns['invalid_date']
  end

  test "should not show charts on 'choose dates' button click when start and end date do not have any associated reports" do
    sign_in @admin_user
    @start_date = (DateTime.current.beginning_of_day + 1.month).to_s
    @end_date = (DateTime.current.beginning_of_day + 1.year).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false
    assert_select ".info-message", "No data found for #{@start_date.to_date.to_s} - #{@end_date.to_date.to_s}."
  end

  test "should not show charts on 'choose dates' button click when start date is after end date" do
    sign_in @admin_user
    @start_date = (DateTime.current.beginning_of_day + 1.year).to_s
    @end_date = (DateTime.current.beginning_of_day + 1.month).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false
    assert_select ".info-message", "Please enter a valid start and end date."
    assert_equal true, @controller.view_assigns['invalid_date']
  end

  test "should hide charts on 'clear selection' button click" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.beginning_of_day + 1.year).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2"
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Clear+Selection'
    assert_redirected_to kpi_dashboard_path
    assert_select ".total-submitted h2", false
    assert_equal true, @controller.view_assigns['selection_cleared']
  end

  test "should return 5 reports for new_reports instance variable when viewing 'all time' KPI data" do
    sign_in @admin_user
    get '/kpi-dashboard?start_date=&end_date=&commit=View+All+Time'
    assert_response :success
    assert_equal 5, @controller.view_assigns['new_reports'].count
    assert_equal true, @controller.view_assigns['all_time']
  end

  test "should return 5 reports for new_reports instance variable when viewing current date KPI data" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.end_of_day + 1.days).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_equal 5, @controller.view_assigns['new_reports'].count
    @controller.view_assigns['new_reports'].each do |report|
      assert_equal true, (report.created_at >= @start_date && report.created_at <= @end_date)
    end
  end

  test "should return 3 reports for deactivated_reports instance variable when viewing 'all time' KPI data" do
    sign_in @admin_user
    get '/kpi-dashboard?start_date=&end_date=&commit=View+All+Time'
    assert_response :success
    assert_equal 3, @controller.view_assigns['deactivated_reports'].count
    assert_equal true, @controller.view_assigns['all_time']
    @controller.view_assigns['deactivated_reports'].each do |report|
      assert_not_equal 'active', report.active_status
    end
  end

  test "should return 3 reports for deactivated_reports instance variable when viewing current date KPI data" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.end_of_day + 1.days).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_equal 3, @controller.view_assigns['deactivated_reports'].count
    @controller.view_assigns['deactivated_reports'].each do |report|
      assert_not_equal 'active', report.active_status
      assert_equal true, (report.deactivated_at >= @start_date && report.deactivated_at <= @end_date)
    end
  end

  test "should return 2 resident users for new_users instance variable when viewing 'all time' KPI data" do
    sign_in @admin_user
    get '/kpi-dashboard?start_date=&end_date=&commit=View+All+Time'
    assert_response :success
    assert_equal 2, @controller.view_assigns['new_users'].count
    assert_equal true, @controller.view_assigns['all_time']
    @controller.view_assigns['new_users'].each do |user|
      assert_equal 'resident', user.role
    end
  end

  test "should return 2 resident users for new_users instance variable when viewing current date KPI data" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.end_of_day + 1.days).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_equal 2, @controller.view_assigns['new_users'].count
    @controller.view_assigns['new_users'].each do |user|
      assert_equal true, (user.created_at >= @start_date && user.created_at <= @end_date)
      assert_equal 'resident', user.role
    end
  end

  test "should return 1 resident user for deactivated_users instance variable when viewing 'all time' KPI data" do
    sign_in @admin_user
    get '/kpi-dashboard?start_date=&end_date=&commit=View+All+Time'
    assert_response :success
    assert_equal 1, @controller.view_assigns['deactivated_users'].count
    assert_equal 'resident', @controller.view_assigns['deactivated_users'][0].role
    assert_equal false, @controller.view_assigns['deactivated_users'][0].active
    assert_equal true, @controller.view_assigns['all_time']
  end

  test "should return 1 resident user for deactivated_users instance variable when viewing current date KPI data" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.end_of_day + 1.days).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_equal 1, @controller.view_assigns['deactivated_users'].count
    assert_equal 'resident', @controller.view_assigns['deactivated_users'][0].role
    assert_equal false, @controller.view_assigns['deactivated_users'][0].active
    assert_equal true, (@controller.view_assigns['deactivated_users'][0].deactivated_at >= @start_date && @controller.view_assigns['deactivated_users'][0].deactivated_at <= @end_date)
  end
  
end
