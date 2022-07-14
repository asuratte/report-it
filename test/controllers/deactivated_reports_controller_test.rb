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

  test "official, resident, and unauthenticated users should not get deactivated-reports" do
    get deactivated_reports_url
    assert_response :redirect
    sign_in @official_user
    get deactivated_reports_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get deactivated_reports_url
    assert_response :redirect
    sign_out @resident_user
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

  test "should return record on incident search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "2"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on address search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Address"
    @search_term = "avenue"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"

    @search_type = "Address"
    @search_term = "apt+2"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on city search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "City"
    @search_term = "atlanta"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on state search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "State"
    @search_term = "GA"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on zip search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "12345"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on description search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Description"
    @search_term = "light"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return no records on search where none exist" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "00000"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p#no_reports", text: "No deactivated reports."
  end

  test "should return record on start end date search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/deactivated-reports?admin_deactivated_start_date=' + @start_date + '&admin_deactivated_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_deactivated_search_radio_value=Dates'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should not return record on future start end date search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @start_date = "06-01-2049"
    @end_date = "06-01-2050"

    get '/deactivated-reports?admin_deactivated_start_date=' + @start_date + '&admin_deactivated_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_deactivated_search_radio_value=Dates'
    assert_response :success
    assert_select "p#no_reports", text: "No deactivated reports."
  end

  test "should clear attribute search and show all reports" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "2"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Clear'
    assert_response :success
    assert_select "thead"
  end

end
