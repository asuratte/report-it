require "test_helper"

class ContentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @content = contents(:one)
    @admin_user = users(:three)
    @resident_user = users(:one)
    @official_user = users(:two)
  end

  test "should get index if admin" do
    sign_in @admin_user
    get contents_url
    assert_response :success
  end

  test "should not get index if resident or official" do
    sign_in @resident_user
    get contents_url
    assert_response :redirect

    sign_in @official_user
    get contents_url
    assert_response :redirect
  end

  test "should show content if admin" do
    sign_in @admin_user
    get content_url(@content)
    assert_response :success
  end

  test "should not show content if resident or official" do
    sign_in @resident_user
    get content_url(@content)
    assert_response :redirect

    sign_in @official_user
    get content_url(@content)
    assert_response :redirect
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_content_url(@content)
    assert_response :success
  end

  test "should not get edit if resident or official" do
    sign_in @resident_user
    get edit_content_url(@content)
    assert_response :redirect

    sign_in @official_user
    get edit_content_url(@content)
    assert_response :redirect
  end

  test "should update content" do
    sign_in @admin_user
    patch content_url(@content), params: { content: { footer_copyright: @content.footer_copyright, homepage_heading_1: @content.homepage_heading_1, logo_image_path: @content.logo_image_path } }
    assert_redirected_to content_url(@content)
  end

end
