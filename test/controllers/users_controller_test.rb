require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @admin_user = users(:three)
    @user2 = users(:two)
  end

  test "should get index" do
    sign_in @admin_user
    get users_url
    assert_response :success
  end

  test "should get new" do
    sign_in @admin_user
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    sign_in @admin_user
    assert_difference('User.count') do
      post users_url, params: { user: { first_name: 'Sally', last_name: "Thompson", address1: '123 West St.', city: 'Omaha', state: 'NE', zip: '50099', phone: '333-444-5555', username: 'test_username', active: 'true', role: 'resident', email: 'test_email@email.com', password: 'test123' } }
    end
    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    sign_in @admin_user
    get user_url(@user2)
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin_user
    get edit_user_url(@user2)
    assert_response :success
  end

  test "should update user" do
    sign_in @admin_user
    patch user_url(@user2), params:  { user: { first_name: 'Charles', last_name: @user2.last_name, address1: @user2.address1, address2: @user2.address2, city: @user2.city, state: @user2.state, zip: @user2.zip, phone: @user2.phone, username: @user2.username, active: @user2.active, role: @user2.role, email: @user2.email, password: @user2.password } }
    assert_redirected_to user_url(@user2)
  end

end