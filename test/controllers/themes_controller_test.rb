require "test_helper"

class ThemesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @theme = themes(:one)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "should get index if admin" do
    sign_in @admin_user
    get themes_url
    assert_response :success
  end

  test "should not get index if resident or official" do
    sign_in @resident_user
    get themes_url
    assert_response :redirect

    sign_in @official_user
    get themes_url
    assert_response :redirect
  end

  test "should allow view of new if admin (new is current theme)" do
    sign_in @admin_user
    get '/themes/new'
    assert_response :success
  end

  test "should not allow view of new if resident or official" do
    sign_in @resident_user
    get '/themes/new'
    assert_response :redirect

    sign_in @official_user
    get '/themes/new'
    assert_response :redirect
  end

  test "should not create theme" do
    sign_in @admin_user
    assert_difference('Theme.count', 0) do
      get themes_url, params: { theme: { name: @theme.name } }
    end
  end

  test "should show theme if admin" do
    sign_in @admin_user
    get theme_url(@theme)
    assert_response :success
  end

  test "should not show theme if resident or official" do
    sign_in @resident_user
    get theme_url(@theme)
    assert_response :redirect

    sign_in @official_user
    get theme_url(@theme)
    assert_response :redirect
  end

  test "should get edit if admin" do
    sign_in @admin_user
    get edit_theme_url(@theme)
    assert_response :success
  end

  test "should not get edit if resident or official" do
    sign_in @resident_user
    get edit_theme_url(@theme)
    assert_response :redirect

    sign_in @official_user
    get edit_theme_url(@theme)
    assert_response :redirect
  end

  test "should update theme" do
    sign_in @admin_user

    get '/themes/1/edit'
    patch theme_url(@theme), params: { theme: { name: "Theme 1" } }
    assert_response :redirect
    get '/themes/1'
    assert_select "span#current_theme", text: "Theme 1"

    get '/themes/1/edit'
    patch theme_url(@theme), params: { theme: { name: "Theme 2" } }
    assert_response :redirect
    get '/themes/1'
    assert_select "span#current_theme", text: "Theme 2"

    get '/themes/1/edit'
    patch theme_url(@theme), params: { theme: { name: "Theme 3" } }
    assert_response :redirect
    get '/themes/1'
    assert_select "span#current_theme", text: "Theme 3"
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
