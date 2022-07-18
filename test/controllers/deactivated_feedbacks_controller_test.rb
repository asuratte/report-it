require "test_helper"

class DeactivatedFeedbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @deactivated_feedback_1 = feedbacks(:three)
    @deactivated_feedback_2 = feedbacks(:four)
    @deactivated_feedback_3 = feedbacks(:five)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
    @search_type = nil
    @search_term = nil
  end

  test "admin user should get deactivated-feedbacks" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success
  end

  test "official, resident, and unauthenticated users should not get deactivated-feedbacks" do
    get deactivated_feedbacks_url
    assert_response :redirect
    sign_in @official_user
    get deactivated_feedbacks_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get deactivated_feedbacks_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "should return feedback on number search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(id: 7, user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "7"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on username search" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Username"
    @search_term = "spr0cket"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on category search" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Category"
    @search_term = "Complaint"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on comment search" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Comment"
    @search_term = "MyString"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return no feedback on search where none exist" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Comment"
    @search_term = "MyString000000"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p.info-message", text: "No deactivated feedback found."
  end

  test "should return feedback on start end date search" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/deactivated-feedbacks?admin_deactivated_feedback_start_date=' + @start_date + '&admin_deactivated_feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_deactivated_feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return error for invalid search dates" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = ""
    @end_date = "06-01-2050"

    get '/deactivated-feedbacks?admin_deactivated_feedback_start_date=' + @start_date + '&admin_deactivated_feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_deactivated_feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "p.info-message", text: "Please enter a valid start and end date."
  end

  test "should clear attribute search and show all feedbacks" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(id: 7, user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "6"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p.info-message", text: "No deactivated feedback found."
    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Clear'
    assert_response :success
    assert_select "thead"
  end
end
