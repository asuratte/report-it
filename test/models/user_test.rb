require "test_helper"

class UserTest < ActiveSupport::TestCase

  setup do
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
    @inactive_user = users(:four)
    @report1 = reports(:one)
    @report5 = reports(:five)
  end

  test "should return true for user one active_for_authentication?" do
    assert @resident_user.active_for_authentication?
  end

  test "should return false for user four active_for_authentication?" do
    assert_equal false, @inactive_user.active_for_authentication?
  end

  test "should return true for user one is_resident?" do
    assert @resident_user.is_resident?
  end

  test "should return false for user one is_admin?" do
    assert_equal false, @resident_user.is_admin?
  end

  test "should return false for user one is_official?" do
    assert_equal false, @resident_user.is_official?
  end

  test "should return true for user two is_official?" do
    assert @official_user.is_official?
  end

  test "should return false for user two is_admin?" do
    assert_equal false, @official_user.is_admin?
  end

  test "should return false for user two is_resident?" do
    assert_equal false, @official_user.is_resident?
  end

  test "should return true for user three is_admin?" do
    assert @admin_user.is_admin?
  end

  test "should return false for user three is_official?" do
    assert_equal false, @admin_user.is_official?
  end

  test "should return false for user three is_resident?" do
    assert_equal false, @admin_user.is_resident?
  end

  test "should return false for user four is_active?" do
    assert_equal false, @inactive_user.is_active?
  end

  test "should return true for user three is_active?" do
    assert @admin_user.is_active?
  end

  test "user attributes cannot be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:city].any?
    assert user.errors[:state].any?
    assert user.errors[:zip].any?
    assert user.errors[:phone].any?
    assert user.errors[:username].any?
    assert user.errors[:first_name].any?
    assert user.errors[:last_name].any?
  end

  test "user should not be created if zip, phone, and username do not pass validation" do
    user1 = User.new
    user1.phone = "asdfghjklzxc"
    user1.zip = "asdfghjklzxc"
    user1.username = "a" * 31
    user1.first_name = @resident_user.first_name
    user1.last_name = @resident_user.last_name
    user1.address1 = @resident_user.address1
    user1.city = @resident_user.city
    user1.state = @resident_user.state
    user1.password = '12345678'
    user1.role = @resident_user.role
    user1.active = @resident_user.active
    user1.email = 'newuser@gmail.com'
    assert user1.invalid?
    assert user1.errors[:phone].any?
    assert user1.errors[:username].any?
    assert user1.errors[:zip].any?
    user2 = User.new
    user2.phone = "4445553333"
    user2.zip = "600978"
    user2.username = "asdf"
    user2.first_name = @resident_user.first_name
    user2.last_name = @resident_user.last_name
    user2.address1 = @resident_user.address1
    user2.city = @resident_user.city
    user2.state = @resident_user.state
    user2.password = '12345678'
    user2.role = @resident_user.role
    user2.active = @resident_user.active
    user2.email = 'newuser@gmail.com'
    assert user2.invalid?
    assert user2.errors[:phone].any?
    assert user2.errors[:username].any?
    assert user2.errors[:zip].any?
  end

  test "user should be created if zip, phone, and username pass validation and all required fields are present" do
    user1 = User.new
    user1.first_name = @resident_user.first_name
    user1.last_name = @resident_user.last_name
    user1.address1 = @resident_user.address1
    user1.city = @resident_user.city
    user1.state = @resident_user.state
    user1.phone = @resident_user.phone
    user1.zip = @resident_user.zip
    user1.username = 'asdffghjkl'
    user1.password = '12345678'
    user1.role = @resident_user.role
    user1.active = @resident_user.active
    user1.email = 'newuser@gmail.com'
    assert user1.valid?
    assert !user1.errors[:phone].any?
    assert !user1.errors[:username].any?
    assert !user1.errors[:zip].any?
  end

  test "user should not be created if email or username are already registered to another user" do
    user1 = User.new
    user1.first_name = @resident_user.first_name
    user1.last_name = @resident_user.last_name
    user1.address1 = @resident_user.address1
    user1.city = @resident_user.city
    user1.state = @resident_user.state
    user1.phone = @resident_user.phone
    user1.zip = @resident_user.zip
    user1.username = @resident_user.username
    user1.password = '12345678'
    user1.role = @resident_user.role
    user1.active = @resident_user.active
    user1.email = @resident_user.email
    assert user1.invalid?
    assert user1.errors[:email].any?
    assert user1.errors[:username].any?
  end

  test "should verify if a user has followed a report" do
    assert_equal false, @resident_user.has_followed?(@report5)
    assert @resident_user.has_followed?(@report1)
  end

  test "should follow a report" do
    assert_equal false, @resident_user.has_followed?(@report5)
    assert_equal 2, @resident_user.followed_reports.count
    @resident_user.follow(@report5)
    assert @resident_user.has_followed?(@report5)
    assert_equal 3, @resident_user.followed_reports.count
  end

  test "should unfollow a report" do
    assert @resident_user.has_followed?(@report1)
    assert_equal 2, @resident_user.followed_reports.count
    @resident_user.follow(@report1)
    assert_equal false, @resident_user.has_followed?(@report1)
    assert_equal 1, @resident_user.followed_reports.count
  end

  test "should verify if a user has confirmed a report" do
    resident4 = users(:four)
    assert_equal false, @resident_user.has_confirmed?(@report1)
    assert resident4.has_confirmed?(@report1)
  end

  test "should confirm a report" do
    report2 = reports(:two)
    assert_equal false, @resident_user.has_confirmed?(report2)
    assert_equal 0, @resident_user.confirmations.count
    @resident_user.confirm(report2)
    assert @resident_user.has_confirmed?(report2)
    assert_equal 1, @resident_user.confirmations.count
  end

  test "should not confirm a report if user has already confirmed that report" do
    resident4 = users(:four)
    assert resident4.has_confirmed?(@report1)
    assert_equal 2, resident4.confirmations.count
    resident4.confirm(@report1)
    assert_equal 2, resident4.confirmations.count
  end
 
end
