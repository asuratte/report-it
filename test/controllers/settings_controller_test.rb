require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @setting = settings(:one)
    @admin_user = users(:three)
    @resident_user = users(:one)
    @official_user = users(:two)
  end

  test "should get index if admin" do
    sign_in @admin_user
    get settings_url
    assert_response :success
  end

  test "should not get index if resident or official" do
    sign_in @resident_user
    get settings_url
    assert_response :redirect

    sign_in @official_user
    get settings_url
    assert_response :redirect
  end

  test "should show setting if admin" do
    sign_in @admin_user
    get setting_url(@setting)
    assert_response :success
  end

  test "should not show setting if resident or official" do
    sign_in @resident_user
    get setting_url(@setting)
    assert_response :redirect

    sign_in @official_user
    get setting_url(@setting)
    assert_response :redirect
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_setting_url(@setting)
    assert_response :success
  end

  test "should not get edit if resident or official" do
    sign_in @resident_user
    get edit_setting_url(@setting)
    assert_response :redirect

    sign_in @official_user
    get edit_setting_url(@setting)
    assert_response :redirect
  end

  test "should update setting" do
    sign_in @admin_user
    patch setting_url(@setting), params: { setting: { footer_copyright: @setting.footer_copyright, homepage_heading_1: @setting.homepage_heading_1, allow_anonymous_reports: false } }
    assert_redirected_to setting_url(@setting)
  end

  test "should attach image to setting" do
    sign_in @admin_user
    get setting_url(@setting)
    assert_response :success
    assert_equal false, @setting.image.attached?

    patch setting_url(@setting), params: { setting: { image: fixture_file_upload('test/fixtures/files/testimage.png', 'image/png') } }
    @setting.reload
    assert @setting.image.attached?
    assert_equal "testimage.png", @setting.image.filename.to_s 
  end

  test "should delete image from setting" do
    sign_in @admin_user
    get setting_url(@setting)
    assert_response :success
    assert_equal false, @setting.image.attached?

    patch setting_url(@setting), params: { setting: { image: fixture_file_upload('test/fixtures/files/testimage.png', 'image/png') } }
    @setting.reload
    assert @setting.image.attached?
    assert_equal "testimage.png", @setting.image.filename.to_s

    delete delete_image_setting_path(image_id: @setting.image.id)
    @setting.reload
    assert_equal false, @setting.image.attached?
  end

end
