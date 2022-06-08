require "test_helper"

class UserTest < ActiveSupport::TestCase

  setup do
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
    @inactive_user = users(:four)
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

end
