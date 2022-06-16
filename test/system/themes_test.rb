require "application_system_test_case"

class ThemesTest < ApplicationSystemTestCase
  setup do
    @theme = themes(:one)
  end

  test "visiting the index" do
    visit themes_url
    assert_selector "h1", text: "Themes"
  end

  test "creating a Theme" do
    visit themes_url
    click_on "New Theme"

    fill_in "Color accent", with: @theme.color_accent
    fill_in "Color button hover", with: @theme.color_button_hover
    fill_in "Color button primary", with: @theme.color_button_primary
    fill_in "Color button secondary", with: @theme.color_button_secondary
    fill_in "Color button text dark", with: @theme.color_button_text_dark
    fill_in "Color button text light", with: @theme.color_button_text_light
    fill_in "Color container link", with: @theme.color_container_link
    fill_in "Color container link hover", with: @theme.color_container_link_hover
    fill_in "Color footer background", with: @theme.color_footer_background
    fill_in "Color header background", with: @theme.color_header_background
    fill_in "Color header text", with: @theme.color_header_text
    fill_in "Color list even", with: @theme.color_list_even
    fill_in "Color list odd", with: @theme.color_list_odd
    fill_in "Color login bar", with: @theme.color_login_bar
    fill_in "Color nav link", with: @theme.color_nav_link
    fill_in "Color nav link hover", with: @theme.color_nav_link_hover
    fill_in "Color page background", with: @theme.color_page_background
    fill_in "Color page border", with: @theme.color_page_border
    fill_in "Color page link", with: @theme.color_page_link
    fill_in "Color page link active", with: @theme.color_page_link_active
    fill_in "Color table before", with: @theme.color_table_before
    fill_in "Color text dark", with: @theme.color_text_dark
    fill_in "Color text light", with: @theme.color_text_light
    fill_in "Font default css", with: @theme.font_default_css
    fill_in "Font google css", with: @theme.font_google_css
    fill_in "Font google css url", with: @theme.font_google_css_url
    fill_in "Hero", with: @theme.hero
    fill_in "Logo", with: @theme.logo
    click_on "Create Theme"

    assert_text "Theme was successfully created"
    click_on "Back"
  end

  test "updating a Theme" do
    visit themes_url
    click_on "Edit", match: :first

    fill_in "Color accent", with: @theme.color_accent
    fill_in "Color button hover", with: @theme.color_button_hover
    fill_in "Color button primary", with: @theme.color_button_primary
    fill_in "Color button secondary", with: @theme.color_button_secondary
    fill_in "Color button text dark", with: @theme.color_button_text_dark
    fill_in "Color button text light", with: @theme.color_button_text_light
    fill_in "Color container link", with: @theme.color_container_link
    fill_in "Color container link hover", with: @theme.color_container_link_hover
    fill_in "Color footer background", with: @theme.color_footer_background
    fill_in "Color header background", with: @theme.color_header_background
    fill_in "Color header text", with: @theme.color_header_text
    fill_in "Color list even", with: @theme.color_list_even
    fill_in "Color list odd", with: @theme.color_list_odd
    fill_in "Color login bar", with: @theme.color_login_bar
    fill_in "Color nav link", with: @theme.color_nav_link
    fill_in "Color nav link hover", with: @theme.color_nav_link_hover
    fill_in "Color page background", with: @theme.color_page_background
    fill_in "Color page border", with: @theme.color_page_border
    fill_in "Color page link", with: @theme.color_page_link
    fill_in "Color page link active", with: @theme.color_page_link_active
    fill_in "Color table before", with: @theme.color_table_before
    fill_in "Color text dark", with: @theme.color_text_dark
    fill_in "Color text light", with: @theme.color_text_light
    fill_in "Font default css", with: @theme.font_default_css
    fill_in "Font google css", with: @theme.font_google_css
    fill_in "Font google css url", with: @theme.font_google_css_url
    fill_in "Hero", with: @theme.hero
    fill_in "Logo", with: @theme.logo
    click_on "Update Theme"

    assert_text "Theme was successfully updated"
    click_on "Back"
  end

  test "destroying a Theme" do
    visit themes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Theme was successfully destroyed"
  end
end
