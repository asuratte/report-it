require "test_helper"

class OfficialControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "official should go to official dashboard on login" do
    sign_in @official_user
    post user_session_url
    assert_redirected_to official_url
  end

  test "official should see status on edit of report" do
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#status_label", text: "Status"
  end

  test "official should see severity on edit of report" do
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#severity_label", text: "Severity"
  end

  test "admin should see status on edit of report" do
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#status_label", text: "Status"
  end

  test "admin should see severity on edit of report" do
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#severity_label", text: "Severity"
  end

  test "resident should not see incident number on report show" do
    sign_in @resident_user

    get '/reports/1'
    assert_response :success
    assert_select "strong#incident_number", false, text: "Incident Number:"
  end

  test "official should see incident number on report show" do
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1'
    assert_response :success
    assert_select "strong#incident_number", text: "Incident Number:"
  end

  test "admin should see incident number on report show" do
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1'
    assert_response :success
    assert_select "strong#incident_number", text: "Incident Number:"
  end

  test "resident should not see incident number on report edit" do
    sign_in @resident_user

    get '/reports/1/edit'
    assert_response :success
    assert_select "strong#incident_number", false, text: "Incident Number:"
  end

  test "official should see incident number on report edit" do
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "strong#incident_number", text: "Incident Number:"
  end

  test "admin should see incident number on report edit" do
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "strong#incident_number", text: "Incident Number:"
  end

  test "should return record on incident search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "1"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on status search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Status"
    @search_term = "new"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on severity search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Severity"
    @search_term = "low"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on address search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Address"
    @search_term = "main"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"

    @search_type = "Address"
    @search_term = "apt+2"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on city search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "City"
    @search_term = "atlanta"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on state search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "State"
    @search_term = "GA"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on zip search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "12345"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on description search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Description"
    @search_term = "trash"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return no records on search where none exist" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "00000"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p.info-message", text: "No reports found."
  end

  test "should return record on start end date search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/official-search?official_start_date=' + @start_date + '&official_end_date=' + @end_date + '&commit=Search+Dates' + '&official_search_radio_value=Dates'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should not return record on future start end date search" do
    sign_in @official_user
    get official_url
    assert_response :success

    @start_date = "06-01-2049"
    @end_date = "06-01-2050"

    get '/official-search?official_start_date=' + @start_date + '&official_end_date=' + @end_date + '&commit=Search+Dates' + '&official_search_radio_value=Dates'
    assert_response :success
    assert_select "p.info-message", text: "No reports found."
  end

  test "should clear attribute search and show all reports" do
    sign_in @official_user
    get official_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "1"

    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    get '/official-search?official_search_type=' + @search_type + '&official_search_term=' + @search_term + '&commit=Clear+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end
end
