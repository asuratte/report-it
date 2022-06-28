require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @category = categories(:one)
    @admin_user = users(:three)
  end

  test "should get index" do
    sign_in @admin_user
    get categories_url
    assert_response :success
  end

  test "should get new" do
    sign_in @admin_user
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    sign_in @admin_user
    assert_difference('Category.count') do
      post categories_url, params: { category: { active: @category.active, name: @category.name } }
    end

    assert_redirected_to category_url(Category.last)
  end

  test "should show category" do
    sign_in @admin_user
    get category_url(@category)
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    sign_in @admin_user
    patch category_url(@category), params: { category: { active: @category.active, name: @category.name } }
    assert_redirected_to category_url(@category)
  end

end
