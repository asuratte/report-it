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
    get '/users/sign_in'
    sign_in @official_user
    get official_url
    assert_response :success
  end

  test "admin should go to official dashboard on login" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success
  end

  test "official should see status on edit of report" do
    get '/users/sign_in'
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#status_label", text: "Status"
  end

  test "official should see severity on edit of report" do
    get '/users/sign_in'
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#severity_label", text: "Severity"
  end

  test "admin should see status on edit of report" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#status_label", text: "Status"
  end

  test "admin should see severity on edit of report" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#severity_label", text: "Severity"
  end

  test "resident should not see incident number on report" do
    get '/users/sign_in'
    sign_in @resident_user

    get '/reports/1'
    assert_response :success
    assert_select "strong#incident_number", false, text: "Incident Number:"
  end

  test "official should see incident number on report" do
    get '/users/sign_in'
    sign_in @official_user
    get official_url
    assert_response :success

    get '/reports/1'
    assert_response :success
    assert_select "strong#incident_number", text: "Incident Number:"
  end

  test "admin should see incident number on report" do
    get '/users/sign_in'
    sign_in @admin_user
    get official_url
    assert_response :success

    get '/reports/1'
    assert_response :success
    assert_select "strong#incident_number", text: "Incident Number:"
  end
end
