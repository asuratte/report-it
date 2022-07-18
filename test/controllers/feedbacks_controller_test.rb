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

  test "should return feedback on number search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(id: 1, user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "1"

    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on username search" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Username"
    @search_term = "spr0cket"

    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on category search" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Category"
    @search_term = "Complaint"

    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on comment search" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Comment"
    @search_term = "MyString"

    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return no feedback on search where none exist" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Comment"
    @search_term = "MyString000000"

    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p.info-message", text: "No feedback found."
  end

  test "should return feedback on start end date search" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/feedbacks?feedback_start_date=' + @start_date + '&feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return error for invalid search dates" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = ""
    @end_date = "06-01-2050"

    get '/feedbacks?feedback_start_date=' + @start_date + '&feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "p.info-message", text: "Please enter a valid start and end date."
  end

  test "should clear attribute search and show all feedbacks" do
    sign_in @admin_user
    get feedbacks_url
    assert_response :success

    @feedback = feedbacks(:one)

    @new_feedback = Feedback.create(id: 1, user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "6"

    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p.info-message", text: "No feedback found."
    get '/feedbacks?feedback_search_type=' + @search_type + '&feedback_search_term=' + @search_term + '&commit=Clear'
    assert_response :success
    assert_select "thead"
  end

  test "should not show feedback for any logged in user if invalid feedback id passed" do
    sign_in @resident_user
    get feedback_url(20000)
    assert_response :redirect
    sign_out @resident_user
    sign_in @official_user
    get feedback_url(20000)
    assert_response :redirect
    sign_out @official_user
    sign_in @admin_user
    get feedback_url(20000)
    assert_response :redirect
  end

  test "should not get edit if logged in user and invalid feedback id passed" do
    sign_in @resident_user
    get feedback_url(20000)
    assert_response :redirect
    sign_out @resident_user
    sign_in @official_user
    get edit_feedback_url(20000)
    assert_response :redirect
    sign_out @official_user
    sign_in @admin_user
    get edit_feedback_url(20000)
    assert_response :redirect
  end
end
