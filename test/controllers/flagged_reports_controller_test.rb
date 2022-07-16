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

  test "official, resident, and unauthenticated users should not get flagged-reports" do
    get flagged_reports_url
    assert_response :redirect
    sign_in @official_user
    get flagged_reports_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get flagged_reports_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "should return record on incident search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "5"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on address search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Address"
    @search_term = "prairie"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"

    @search_type = "Address"
    @search_term = "#300"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on city search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "City"
    @search_term = "macon"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on state search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "State"
    @search_term = "GA"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on zip search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "33442"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on description search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Description"
    @search_term = "important"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return no records on search where none exist" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "00000"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p.info-message", text: "No flagged reports found."
  end

  test "should return record on start end date search" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/flagged-reports?admin_flagged_report_start_date=' + @start_date + '&admin_flagged_report_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_flagged_report_search_radio_value=Dates'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return error for invalid search dates" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @start_date = ""
    @end_date = "06-01-2050"

    get '/flagged-reports?admin_flagged_report_start_date=' + @start_date + '&admin_flagged_report_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_flagged_report_search_radio_value=Dates'
    assert_response :success
    assert_select "p.info-message", text: "Please enter a valid start and end date."
  end

  test "should clear attribute search and show all reports" do
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "5"

    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    get '/flagged-reports?admin_flagged_report_search_type=' + @search_type + '&admin_flagged_report_search_term=' + @search_term + '&commit=Clear'
    assert_response :success
    assert_select "thead"
  end

end
