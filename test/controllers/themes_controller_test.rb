require "test_helper"

class ThemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @theme = themes(:one)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "should get index" do
    sign_in @admin_user
    get themes_url
    assert_response :success
  end

  test "should get new" do
    sign_in @admin_user
    get new_theme_url
    assert_response :success
  end

  test "should create theme" do
    sign_in @admin_user
    assert_difference('Theme.count') do
      post themes_url, params: { theme: { element: @theme.element, value: @theme.value } }
    end

    assert_redirected_to theme_url(Theme.last)
  end

  test "should show theme" do
    sign_in @admin_user
    get theme_url(@theme)
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_theme_url(@theme)
    assert_response :success
  end

  test "should update theme" do
    sign_in @admin_user
    patch theme_url(@theme), params: { theme: { element: @theme.element, value: @theme.value } }
    assert_redirected_to theme_url(@theme)
  end

  test "should not allow resident to access" do
    sign_in @resident_user
    get edit_theme_url(@theme)
    assert_response :redirect
  end

  test "should not allow official to access" do
    sign_in @official_user
    get edit_theme_url(@theme)
    assert_response :redirect
  end

  test "should allow admin to access" do
    sign_in @admin_user
    get edit_theme_url(@theme)
    assert_response :success
  end

  test "should not allow anyone to destroy" do
    sign_in @resident_user
    get '/theme/1/destroy'
    assert_response :redirect

    sign_in @official_user
    get '/theme/1/destroy'
    assert_response :redirect

    sign_in @admin_user
    get '/theme/1/destroy'
    assert_response :redirect
  end
end
