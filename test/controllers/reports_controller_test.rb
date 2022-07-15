require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @inactive_report = reports(:two)
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
    get new_report_path(category: "Transportation and streets", subcategory: "Road hazard complaint")
    assert_response :success
  end

  test "should not get new with fake categories if signed in" do
    sign_in @resident_user
    get new_report_path(category: "Fruits and Vegetables", subcategory: "Pears")
    assert_response :redirect
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

  test "should create report with resident information" do
    sign_in @resident_user
    assert_difference('Report.count') do
      post reports_url, params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, severity: @report.severity, state: @report.state, status: @report.status, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip } }
    end

    assert_redirected_to resident_path
  end

  test "should create report without resident information" do
    sign_in @resident_user
    assert_difference('Report.count') do
      post reports_url, params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, severity: @report.severity, state: @report.state, status: @report.status, subcategory: @report.subcategory, zip: @report.zip } }
    end

    assert_redirected_to resident_path
  end

  test "should show active report for all user roles" do
    get report_url(@report)
    assert_response :success
    sign_in @admin_user
    get report_url(@report)
    assert_response :success
    sign_out @admin_user
    sign_in @official_user
    get report_url(@report)
    assert_response :success
    sign_out @official_user
    sign_in @resident_user
    get report_url(@report)
    assert_response :success
    sign_out @resident_user
  end

  test "should show inactive report for admin user" do
    sign_in @admin_user
    get report_url(@inactive_report)
    assert_response :success
  end

  test "should not show inactive report for official or resident user" do
    sign_in @official_user
    get report_url(@inactive_report)
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get report_url(@inactive_report)
    assert_response :redirect
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

  test "should update report active_status as admin" do
    sign_in @admin_user
    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, state: @report.state, status: @report.status, severity: @report.severity, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip, active_status: "abuse" } }
    assert_redirected_to report_url(@report)
  end

  test "should populate deactivated_at date when report is updated to any active_status other than 'active'" do
    sign_in @admin_user
    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, state: @report.state, status: @report.status, severity: @report.severity, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip, active_status: "abuse" } }
    @report.reload
    assert_not_nil @report.deactivated_at

    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, state: @report.state, status: @report.status, severity: @report.severity, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip, active_status: "spam" } }
    @report.reload
    assert_not_nil @report.deactivated_at

    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, state: @report.state, status: @report.status, severity: @report.severity, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip, active_status: "outside_area" } }
    @report.reload
    assert_not_nil @report.deactivated_at
  end

  test "should show nil for deactivated_at date when report is updated to active_status 'active'" do
    sign_in @admin_user
    patch report_url(@report), params: { report: { address1: @report.address1, address2: @report.address2, category: @report.category, city: @report.city, description: @report.description, state: @report.state, status: @report.status, severity: @report.severity, subcategory: @report.subcategory, user_id: @report.user_id, zip: @report.zip, active_status: "active" } }
    @report.reload
    assert_nil @report.deactivated_at
  end

  test "should destroy report" do
    sign_in @resident_user
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end

  test "should delete image from report" do
    sign_in @resident_user
    get report_url(@report)
    assert_response :success
    assert_equal false, @report.image.attached?

    patch report_url(@report), params: { report: { image: fixture_file_upload('test/fixtures/files/testimage.png', 'image/png') } }
    @report.reload
    assert @report.image.attached?
    assert_equal "testimage.png", @report.image.filename.to_s

    delete delete_image_report_path(image_id: @report.image.id)
    @report.reload
    assert_equal false, @report.image.attached?
  end

  test "should return record on incident search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "1"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on category search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "Category"
    @search_term = "trash"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on address search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "Address"
    @search_term = "main"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"

    @search_type = "Address"
    @search_term = "apt+2"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on city search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "City"
    @search_term = "atlanta"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on state search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "State"
    @search_term = "GA"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on zip search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "Zip"
    @search_term = "12345"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on description search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "Description"
    @search_term = "trash"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should return record on start end date search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/reports?resident_start_date=' + @start_date + '&resident_end_date=' + @end_date + '&commit=Search+Dates'
    assert_response :success
    assert_select "th#date_reported", text: "Date Reported"
  end

  test "should not return record on future start end date search" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @start_date = "06-01-2049"
    @end_date = "06-01-2050"

    get '/reports?resident_start_date=' + @start_date + '&resident_end_date=' + @end_date + '&commit=Search+Dates'
    assert_response :success
    assert_select "p#no_reports", text: "No reports found."
  end

  test "should clear attribute search and show all reports" do
    sign_in @resident_user
    get resident_url
    assert_response :success

    @search_type = "Incident+No."
    @search_term = "1"

    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    get '/reports?resident_search_type=' + @search_type + '&resident_search_term=' + @search_term + '&commit=Clear+Attribute'
    assert_response :success
    assert_select "thead#true"
  end

end
