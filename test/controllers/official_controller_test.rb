require "test_helper"

class OfficialControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    @user = users(:one)
  end

  test "official should go to official dashboard on login" do
    get '/users/sign_in'
    sign_in users(:two)
    get official_url
    assert_response :success
  end

  test "admin should go to official dashboard on login" do
    get '/users/sign_in'
    sign_in users(:three)
    get official_url
    assert_response :success
  end

  test "official should see status on edit of report" do
    get '/users/sign_in'
    sign_in users(:two)
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#status_label", text: "Status"
  end

  test "official should see severity on edit of report" do
    get '/users/sign_in'
    sign_in users(:two)
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#severity_label", text: "Severity"
  end

  test "admin should see status on edit of report" do
    get '/users/sign_in'
    sign_in users(:three)
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#status_label", text: "Status"
  end

  test "admin should see severity on edit of report" do
    get '/users/sign_in'
    sign_in users(:three)
    get official_url
    assert_response :success

    get '/reports/1/edit'
    assert_response :success
    assert_select "label#severity_label", text: "Severity"
  end
end
