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

  test "should show charts on 'choose dates' button click when start and end date are provided" do
    sign_in @admin_user
    @start_date = DateTime.current.beginning_of_day.to_s
    @end_date = (DateTime.current.beginning_of_day + 1.year).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", text: "Total Number of Reports Submitted"
  end

  test "should not show charts on 'choose dates' button click when start and end date are not provided" do
    sign_in @admin_user
    get '/kpi-dashboard?start_date=&end_date=&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false, text: "Total Number of Reports Submitted"
  end

  test "should not show charts on 'choose dates' button click when start and end date do not have any associated reports" do
    sign_in @admin_user
    @start_date = (DateTime.current.beginning_of_day + 1.month).to_s
    @end_date = (DateTime.current.beginning_of_day + 1.year).to_s
    get '/kpi-dashboard?start_date=' + @start_date + '&end_date=' + @end_date + '&commit=Choose+Dates'
    assert_response :success
    assert_select ".total-submitted h2", false, text: "Total Number of Reports Submitted"
  end
  
end
