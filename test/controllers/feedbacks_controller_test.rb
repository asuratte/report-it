require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @feedback = feedbacks(:one)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "should not show feedback if not logged in" do
    get feedback_url(@feedback)
    assert_response :redirect
  end

  test "should not show feedback index if not logged in" do
    get "/feedbacks"
    assert_response :redirect
  end

  test "should not show feedback new if not logged in" do
    get new_feedback_url
    assert_response :redirect
  end

  test "should not show feedback edit if not logged in" do
    get "/feedbacks/1/edit"
    assert_response :redirect
  end

  test "should get feedback index for admin and official" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    sign_in @official_user
    get feedbacks_url
    assert_response :success
  end

  test "should not get feedback index for resident" do
    sign_in @resident_user
    get feedbacks_url
    assert_response :redirect
  end

  test "should get feedback new for resident" do
    sign_in @resident_user
    get new_feedback_url
    assert_response :success
  end

  test "should not get feedback new for admin and official" do
    sign_in @admin_user
    get new_feedback_url
    assert_response :redirect

    sign_in @official_user
    get new_feedback_url
    assert_response :redirect
  end

  test "should create feedback for resident" do
    sign_in @resident_user
    assert_difference('Feedback.count') do
      post feedbacks_url, params: { feedback: { active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status, user_id: @feedback.user_id } }
    end

    assert_redirected_to feedback_url(Feedback.last)
  end

  test "should show feedback for official and admin" do
    sign_in @official_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get feedback_url(@new_feedback)
    assert_response :success

    sign_in @admin_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get feedback_url(@new_feedback)
    assert_response :success
  end

  test "should show feedback for resident who logged feedback" do
    sign_in @resident_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get feedback_url(@new_feedback)
    assert_response :success
  end

  test "should show thank you for resident who logged feedback" do
    sign_in @resident_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get feedback_url(@new_feedback)
    assert_select "h1#thank_you", text: "Thank You"
  end

  test "should show feedback not thank you for official and admin" do
    sign_in @official_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get feedback_url(@new_feedback)
    assert_select "strong#feedback_number", text: "Feedback Number:"

    sign_in @admin_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get feedback_url(@new_feedback)
    assert_select "strong#feedback_number", text: "Feedback Number:"
  end

  test "should not show feedback for resident who did not log feedback" do
    sign_in @resident_user
    get feedback_url(feedbacks(:two))
    assert_response :redirect
  end

  test "should get edit for official and admin" do
    sign_in @admin_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get edit_feedback_url(@new_feedback)
    assert_response :success

    sign_in @official_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get edit_feedback_url(@new_feedback)
    assert_response :success
  end

  test "should not get edit for resident" do
    sign_in @resident_user

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    get edit_feedback_url(@new_feedback)
    assert_response :redirect
  end

  test "should update feedback for official" do
    sign_in @official_user

    patch feedback_url(@feedback), params: { feedback: { active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status, user_id: @feedback.user_id } }
    assert_redirected_to feedback_url(@feedback)
  end

  test "should update feedback for admin" do
    sign_in @admin_user

    patch feedback_url(@feedback), params: { feedback: { active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status, user_id: @feedback.user_id } }
    assert_redirected_to feedback_url(@feedback)
  end
end
