require "test_helper"

class SubcategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @subcategory = subcategories(:one)
    @admin_user = users(:three)
    @resident_user = users(:one)
    @official_user = users(:two)
  end

  test "should get index if admin" do
    sign_in @admin_user
    get subcategories_url
    assert_response :success
  end

  test "should not get index if official, resident, or unauthenticated" do
    get subcategories_url
    assert_response :redirect
    sign_in @official_user
    get subcategories_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get subcategories_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "should get new if admin" do
    sign_in @admin_user
    get new_subcategory_url
    assert_response :success
  end

  test "should not get new if official, resident, or unauthenticated" do
    get new_subcategory_url
    assert_response :redirect
    sign_in @official_user
    get new_subcategory_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get new_subcategory_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "should create subcategory" do
    sign_in @admin_user
    assert_difference('Subcategory.count') do
      post subcategories_url, params: { subcategory: { active: @subcategory.active, category_id: @subcategory.category_id, name: @subcategory.name, description: @subcategory.description } }
    end

    assert_redirected_to subcategory_url(Subcategory.last)
  end

  test "should show subcategory if admin" do
    sign_in @admin_user
    get subcategory_url(@subcategory)
    assert_response :success
  end

  test "should not show subcategory if official, resident, or unauthenticated" do
    get subcategory_url(@subcategory)
    assert_response :redirect
    sign_in @official_user
    get subcategory_url(@subcategory)
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get subcategory_url(@subcategory)
    assert_response :redirect
    sign_out @resident_user
  end

  test "should get edit if admin" do
    sign_in @admin_user
    get edit_subcategory_url(@subcategory)
    assert_response :success
  end

  test "should not get edit if official, resident, or unauthenticated" do
    get edit_subcategory_url(@subcategory)
    assert_response :redirect
    sign_in @official_user
    get edit_subcategory_url(@subcategory)
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get edit_subcategory_url(@subcategory)
    assert_response :redirect
    sign_out @resident_user
  end

  test "should update subcategory" do
    sign_in @admin_user
    patch subcategory_url(@subcategory), params: { subcategory: { active: @subcategory.active, category_id: @subcategory.category_id, name: @subcategory.name, description: @subcategory.description } }
    assert_redirected_to subcategory_url(@subcategory)
  end

end
