require "test_helper"

class SubcategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @subcategory = subcategories(:one)
    @admin_user = users(:three)
  end

  test "should get index" do
    sign_in @admin_user
    get subcategories_url
    assert_response :success
  end

  test "should get new" do
    sign_in @admin_user
    get new_subcategory_url
    assert_response :success
  end

  test "should create subcategory" do
    sign_in @admin_user
    assert_difference('Subcategory.count') do
      post subcategories_url, params: { subcategory: { active: @subcategory.active, category_id: @subcategory.category_id, name: @subcategory.name, description: @subcategory.description } }
    end

    assert_redirected_to subcategory_url(Subcategory.last)
  end

  test "should show subcategory" do
    sign_in @admin_user
    get subcategory_url(@subcategory)
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_subcategory_url(@subcategory)
    assert_response :success
  end

  test "should update subcategory" do
    sign_in @admin_user
    patch subcategory_url(@subcategory), params: { subcategory: { active: @subcategory.active, category_id: @subcategory.category_id, name: @subcategory.name, description: @subcategory.description } }
    assert_redirected_to subcategory_url(@subcategory)
  end

end
