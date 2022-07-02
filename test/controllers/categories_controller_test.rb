require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @category = categories(:one)
    @admin_user = users(:three)
    @resident_user = users(:one)
    @official_user = users(:two)
  end

  test "should get index if admin" do
    sign_in @admin_user
    get categories_url
    assert_response :success
  end

  test "should not get index if official, resident, or unauthenticated" do
    get categories_url
    assert_response :redirect
    sign_in @official_user
    get categories_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get categories_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "should get new if admin" do
    sign_in @admin_user
    get new_category_url
    assert_response :success
  end

  test "should not get new if official, resident, or unauthenticated" do
    get new_category_url
    assert_response :redirect
    sign_in @official_user
    get new_category_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get new_category_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "should create category" do
    sign_in @admin_user
    assert_difference('Category.count') do
      post categories_url, params: { category: { active: @category.active, name: @category.name } }
    end

    assert_redirected_to category_url(Category.last)
  end

  test "should show category if admin" do
    sign_in @admin_user
    get category_url(@category)
    assert_response :success
  end

  test "should not show category if official, resident, or unauthenticated" do
    get category_url(@category)
    assert_response :redirect
    sign_in @official_user
    get category_url(@category)
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get category_url(@category)
    assert_response :redirect
    sign_out @resident_user
  end

  test "should get edit if admin" do
    sign_in @admin_user
    get edit_category_url(@category)
    assert_response :success
  end

  test "should not get edit if official, resident, or unauthenticated" do
    get edit_category_url(@category)
    assert_response :redirect
    sign_in @official_user
    get edit_category_url(@category)
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get edit_category_url(@category)
    assert_response :redirect
    sign_out @resident_user
  end

  test "should update category" do
    sign_in @admin_user
    patch category_url(@category), params: { category: { active: @category.active, name: @category.name } }
    assert_redirected_to category_url(@category)
  end

end
