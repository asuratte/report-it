require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @feedback_1 = feedbacks(:one)
    @feedback_2 = feedbacks(:two)
    @feedback_3 = feedbacks(:three)
    @feedback_4 = feedbacks(:four)
    @feedback_5 = feedbacks(:five)
    @feedback_6 = feedbacks(:six)
    @feedback_7 = feedbacks(:seven)
  end

  test "feedback attributes cannot be empty" do
    feedback = Feedback.new
    feedback.user_id = @feedback_1.user_id
    feedback.category = @feedback_1.category
    feedback.status = @feedback_1.status
    feedback.comment = nil
    feedback.active_status = @feedback_1.active_status

    assert feedback.invalid?
    assert feedback.errors[:comment].any?
  end

  test "feedback should not create if feedback comment over 200" do
    new_feedback = Feedback.new
    new_feedback.user_id = @feedback_1.user_id
    new_feedback.category = @feedback_1.category
    new_feedback.status = @feedback_1.status
    new_feedback.comment = "a" * 205
    new_feedback.active_status = @feedback_1.active_status

    assert new_feedback.invalid?
    assert new_feedback.errors[:comment].any?
  end

  test "feedback should be created if required fields present" do
    feedback = Feedback.new
    feedback.user_id = 1
    feedback.category = "Complaint"
    feedback.status = "New"
    feedback.comment = "Sucks"
    feedback.active_status = 0
    feedback.user = users(:one)
    assert feedback.valid?
  end

  test "should return true if feedback_1 is_active?" do
    assert @feedback_1.is_active?
    assert_equal @feedback_1.active_status, 0
  end

  test "should return false for feedback_5 with active_status 'spam' is_active?" do
    assert !@feedback_5.is_active?
    assert_equal @feedback_5.active_status, 1
  end

  test "should return false for feedback_6 with active_status 'abuse' is_active?" do
    assert !@feedback_6.is_active?
    assert_equal @feedback_6.active_status, 2
  end

  test "search returns a single feedback" do
    feedback = Feedback.feedback_search("Feedback No.", @feedback_1.id.to_s)
    assert_equal 1, feedback.count
  end

  test "search returns multiple feedbacks" do
    feedback = Feedback.feedback_search("Category", "Complaint")
    assert feedback.count > 1
  end

  test "search returns no feedback" do
    feedback = Feedback.feedback_search("Feedback No.", "0")
    assert_equal 0, feedback.count
  end

  test "search returns all feedbacks if no search parameters specified" do
    feedback = Feedback.feedback_search("", "")
    assert_equal 7, feedback.count
  end

  test "search finds feedbacks by number" do
    feedback = Feedback.feedback_search("Feedback No.", @feedback_1.id.to_s)
    assert_equal 1, feedback.count
    assert_equal "MyString1", feedback.first.comment
  end

  test "search finds no feedbacks for invalid numbers" do
    feedback = Feedback.feedback_search("Feedback No.", "test")
    assert_equal 0, feedback.count
    feedback = Feedback.feedback_search("Feedback No.", "1.5")
    assert_equal 0, feedback.count
  end

  test "search finds feedbacks by username" do
    @new_feedback = Feedback.create(
    user: users(:five),
    category: "Complaint",
    comment: "MyString50",
    status: "Flagged",
    active_status: 2)

    feedback = Feedback.feedback_search("Username", "mitc1209")
    assert_equal 1, feedback.count
    assert_equal "MyString50", feedback.first.comment
  end

  test "search finds feedbacks by category" do
    feedback = Feedback.feedback_search("Category", "Suggestion")
    assert_equal 1, feedback.count
    assert_equal "MyString6", feedback.first.comment
  end

  test "search finds feedbacks by comment" do
    feedback = Feedback.feedback_search("Comment", @feedback_1.comment)
    assert_equal 1, feedback.count
    assert_equal "MyString1", feedback.first.comment
  end

  test "search finds feedbacks by status" do
    feedback = Feedback.feedback_search("Status", @feedback_1.status)
    assert_equal 1, feedback.count
  end
end
