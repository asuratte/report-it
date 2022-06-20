require "test_helper"

class ContentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @content = contents(:one)
    @admin_user = users(:three)
  end

  test "should get index" do
    sign_in @admin_user
    get contents_url
    assert_response :success
  end

  test "should show content" do
    sign_in @admin_user
    get content_url(@content)
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_content_url(@content)
    assert_response :success
  end

  test "should update content" do
    sign_in @admin_user
    patch content_url(@content), params: { content: { footer_copyright: @content.footer_copyright, homepage_heading_1: @content.homepage_heading_1, logo_image_path: @content.logo_image_path } }
    assert_redirected_to content_url(@content)
  end

end
