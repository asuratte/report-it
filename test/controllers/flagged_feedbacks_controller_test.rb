require "test_helper"

class FlaggedFeedbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @flagged_feedback_1 = feedbacks(:three)
    @flagged_feedback_2 = feedbacks(:four)
    @flagged_feedback_3 = feedbacks(:five)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
    @search_type = nil
    @search_term = nil
  end

  test "admin user should get flagged-feedbacks" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success
  end

  test "official, resident, and unauthenticated users should not get flagged-feedbacks" do
    get flagged_feedbacks_url
    assert_response :redirect
    sign_in @official_user
    get flagged_feedbacks_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get flagged_feedbacks_url
    assert_response :redirect
    sign_out @resident_user
  end

  test "official and resident users should not get flagged-feedbacks" do
    sign_in @official_user
    get flagged_feedbacks_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get flagged_feedbacks_url
    assert_response :redirect
  end

  test "should return feedback on number search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(id: 7, user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "7"

    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on username search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Username"
    @search_term = "spr0cket"

    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on category search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Category"
    @search_term = "Complaint"

    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return feedback on comment search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Comment"
    @search_term = "MyString"

    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should return no feedback on search where none exist" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Comment"
    @search_term = "MyString000000"

    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p#no_feedback", text: "No flagged feedback."
  end

  test "should return feedback on start end date search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = "06-01-2022"
    @end_date = "06-01-2050"

    get '/flagged-feedbacks?admin_flagged_feedback_start_date=' + @start_date + '&admin_flagged_feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_flagged_feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "th#date_submitted", text: "Date Submitted"
  end

  test "should not return feedback on future start end date search" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = "06-01-2049"
    @end_date = "06-01-2050"

    get '/flagged-feedbacks?admin_flagged_feedback_start_date=' + @start_date + '&admin_flagged_feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_flagged_feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "p#no_feedback", text: "No flagged feedback."
  end

  test "should clear attribute search and show all feedbacks" do
    sign_in @admin_user
    get flagged_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:four)

    @new_feedback = Feedback.create(id: 7, user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "6"

    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    assert_select "p#no_feedback", text: "No flagged feedback."
    get '/flagged-feedbacks?admin_flagged_feedback_search_type=' + @search_type + '&admin_flagged_feedback_search_term=' + @search_term + '&commit=Clear'
    assert_response :success
    assert_select "thead"
  end
end
