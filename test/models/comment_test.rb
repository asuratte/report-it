require "test_helper"

class CommentTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @comment_1 = comments(:one)
    @comment_2 = comments(:two)
    @comment_3 = comments(:three)
    @comment_4 = comments(:four)
  end

  test "comment attributes cannot be empty" do
    comment = Comment.new
    comment.user_id = @comment_1.user_id
    comment.report_id = @comment_1.report_id
    comment.comment = nil

    assert comment.invalid?
    assert comment.errors[:comment].any?
  end

  test "comment should not create if over 200" do
    new_comment = Comment.new
    new_comment.user_id = @comment_1.user_id
    new_comment.report_id = @comment_1.report_id
    new_comment.comment = "a" * 205

    assert new_comment.invalid?
    assert new_comment.errors[:comment].any?
  end

end
