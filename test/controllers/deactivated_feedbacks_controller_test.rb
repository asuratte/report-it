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

  test "official and resident users should not get deactivated-feedbacks" do
    sign_in @official_user
    get deactivated_feedbacks_url
    assert_response :redirect
    sign_out @official_user
    sign_in @resident_user
    get deactivated_feedbacks_url
    assert_response :redirect
  end

  test "should return record on feedback number search" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "5"

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
    assert_select "p#no_feedback", text: "No deactivated feedback."
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

  test "should not return feedback on future start end date search" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @start_date = "06-01-2049"
    @end_date = "06-01-2050"

    get '/deactivated-feedbacks?admin_deactivated_feedback_start_date=' + @start_date + '&admin_deactivated_feedback_end_date=' + @end_date + '&commit=Search+Dates' + '&admin_deactivated_feedback_search_radio_value=Dates'
    assert_response :success
    assert_select "p#no_feedback", text: "No deactivated feedback."
  end

  test "should clear attribute search and show all feedbacks" do
    sign_in @admin_user
    get deactivated_feedbacks_url
    assert_response :success

    @feedback = feedbacks(:five)

    @new_feedback = Feedback.create(user_id: @resident_user.id, active_status: @feedback.active_status, category: @feedback.category, comment: @feedback.comment, status: @feedback.status)

    @search_type = "Feedback+No."
    @search_term = "1"

    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Search+Attribute'
    assert_response :success
    get '/deactivated-feedbacks?admin_deactivated_feedback_search_type=' + @search_type + '&admin_deactivated_feedback_search_term=' + @search_term + '&commit=Clear'
    assert_response :success
    assert_select "thead"
  end
end
