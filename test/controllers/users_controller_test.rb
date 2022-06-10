require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { first_name: 'Sally', last_name: "Thompson", address1: '123 West St.', city: 'Omaha', state: 'NE', zip: '50099', phone: '333-444-5555', username: 'test_username', active: 'true', role: 'resident', email: 'test_email@email.com', password: 'test123' } }
    end
    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params:  { user: { first_name: 'Charles', last_name: @user.last_name, address1: @user.address1, address2: @user.address2, city: @user.city, state: @user.state, zip: @user.zip, phone: @user.phone, username: @user.username, active: @user.active, role: @user.role, email: @user.email, password: @user.password } }
    assert_redirected_to user_url(@user)
  end

end