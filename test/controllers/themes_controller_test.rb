require "test_helper"

class ThemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @theme = themes(:one)
  end

  test "should get index" do
    get themes_url
    assert_response :success
  end

  test "should get new" do
    get new_theme_url
    assert_response :success
  end

  test "should create theme" do
    assert_difference('Theme.count') do
      post themes_url, params: { theme: { color_accent: @theme.color_accent, color_button_hover: @theme.color_button_hover, color_button_primary: @theme.color_button_primary, color_button_secondary: @theme.color_button_secondary, color_button_text_dark: @theme.color_button_text_dark, color_button_text_light: @theme.color_button_text_light, color_container_link: @theme.color_container_link, color_container_link_hover: @theme.color_container_link_hover, color_footer_background: @theme.color_footer_background, color_header_background: @theme.color_header_background, color_header_text: @theme.color_header_text, color_list_even: @theme.color_list_even, color_list_odd: @theme.color_list_odd, color_login_bar: @theme.color_login_bar, color_nav_link: @theme.color_nav_link, color_nav_link_hover: @theme.color_nav_link_hover, color_page_background: @theme.color_page_background, color_page_border: @theme.color_page_border, color_page_link: @theme.color_page_link, color_page_link_active: @theme.color_page_link_active, color_table_before: @theme.color_table_before, color_text_dark: @theme.color_text_dark, color_text_light: @theme.color_text_light, font_default_css: @theme.font_default_css, font_google_css: @theme.font_google_css, font_google_css_url: @theme.font_google_css_url, hero: @theme.hero, logo: @theme.logo } }
    end

    assert_redirected_to theme_url(Theme.last)
  end

  test "should show theme" do
    get theme_url(@theme)
    assert_response :success
  end

  test "should get edit" do
    get edit_theme_url(@theme)
    assert_response :success
  end

  test "should update theme" do
    patch theme_url(@theme), params: { theme: { color_accent: @theme.color_accent, color_button_hover: @theme.color_button_hover, color_button_primary: @theme.color_button_primary, color_button_secondary: @theme.color_button_secondary, color_button_text_dark: @theme.color_button_text_dark, color_button_text_light: @theme.color_button_text_light, color_container_link: @theme.color_container_link, color_container_link_hover: @theme.color_container_link_hover, color_footer_background: @theme.color_footer_background, color_header_background: @theme.color_header_background, color_header_text: @theme.color_header_text, color_list_even: @theme.color_list_even, color_list_odd: @theme.color_list_odd, color_login_bar: @theme.color_login_bar, color_nav_link: @theme.color_nav_link, color_nav_link_hover: @theme.color_nav_link_hover, color_page_background: @theme.color_page_background, color_page_border: @theme.color_page_border, color_page_link: @theme.color_page_link, color_page_link_active: @theme.color_page_link_active, color_table_before: @theme.color_table_before, color_text_dark: @theme.color_text_dark, color_text_light: @theme.color_text_light, font_default_css: @theme.font_default_css, font_google_css: @theme.font_google_css, font_google_css_url: @theme.font_google_css_url, hero: @theme.hero, logo: @theme.logo } }
    assert_redirected_to theme_url(@theme)
  end

  test "should destroy theme" do
    assert_difference('Theme.count', -1) do
      delete theme_url(@theme)
    end

    assert_redirected_to themes_url
  end
end
