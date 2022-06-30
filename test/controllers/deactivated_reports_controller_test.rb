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

  test "should return record on incident search" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "2"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on address search" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Address"
    @search_term = "avenue"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"

    @search_type = "Address"
    @search_term = "apt+2"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on city search" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "City"
    @search_term = "atlanta"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on state search" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "State"
    @search_term = "GA"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on zip search" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "12345"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on description search" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Description"
    @search_term = "light"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return no records on search where none exist" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "00000"

    get '/deactivated-reports?admin_deactivated_search_type=' + @search_type + '&admin_deactivated_search_term=' + @search_term + '&commit=Search'
    assert_response :success
    assert_select "p#no_reports", text: "No deactivated reports."
  end

end
