require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @comment = comments(:one)
    @report = reports(:one)
    @resident_user = users(:one)
    @official_user = users(:two)
    @admin_user = users(:three)
  end

  test "should not get index for any role" do
    sign_in @resident_user
    get comments_url
    assert_redirected_to root_url

    sign_in @official_user
    get comments_url
    assert_redirected_to root_url

    sign_in @admin_user
    get comments_url
    assert_redirected_to root_url
  end

  test "should not get new comment for resident" do
    sign_in @resident_user
    get reports_url(@report)
    assert_response :success

    get new_comment_url
    assert_redirected_to root_url
  end

  test "should create new comment for official or admin" do
    sign_in @official_user
    get '/reports/' + @report.id.to_s
    assert_response :success

    get '/submit_comment?user_id=' + @comment.user_id.to_s + '&report_id=' + @report.id.to_s + '&comment=' + @comment.comment
    get '/reports/' + @report.id.to_s
    assert_select "td#report_comment", text: "MyString1"

    sign_in @admin_user
    get '/reports/' + @report.id.to_s
    assert_response :success

    get '/submit_comment?user_id=' + @comment.user_id.to_s + '&report_id=' + @report.id.to_s + '&comment=' + @comment.comment
    get '/reports/' + @report.id.to_s
    assert_select "td#report_comment", text: "MyString1"
  end

  test "should not show comment for resident" do
    sign_in @resident_user
    get '/comments/' + @comment.id.to_s
    assert_redirected_to root_url
  end

  test "should show comment for admin or official" do
    @show_comment = Comment.create(user_id: @official_user.id, report_id: @report.id, comment: 'Testing')

    sign_in @admin_user
    get comment_url(@show_comment)
    assert_response :success

    sign_in @official_user
    get comment_url(@show_comment)
    assert_response :success
  end

  test "should not get edit comment for resident" do
    sign_in @resident_user
    get edit_comment_url(@comment)
    assert_redirected_to root_url
  end

  test "should get submit, edit and show updated comment for official" do
    sign_in @official_user
    get '/reports/' + @report.id.to_s
    assert_response :success

    assert_equal(4, Comment.count)

    @new_comment = Comment.create(user_id: @official_user.id, report_id: @report.id, comment: 'Testing')

    get '/reports/' + @report.id.to_s
    assert_select "td#report_comment", text: "Testing"

    assert_equal(5, Comment.count)

    Comment.update(user_id: @official_user.id, report_id: @report.id, comment: 'Testing2')

    get comment_url(@new_comment)
    assert_response :success
    assert_select "span#comment", text: "Testing2"

    assert_equal(5, Comment.count)
  end

  test "should get submit, edit and show updated comment for admin" do
    sign_in @admin_user
    get '/reports/' + @report.id.to_s
    assert_response :success

    assert_equal(4, Comment.count)

    @new_comment = Comment.create(user_id: @official_user.id, report_id: @report.id, comment: 'Testing')

    get '/reports/' + @report.id.to_s
    assert_select "td#report_comment", text: "Testing"

    assert_equal(5, Comment.count)

    Comment.update(user_id: @official_user.id, report_id: @report.id, comment: 'Testing2')

    get comment_url(@new_comment)
    assert_response :success
    assert_select "span#comment", text: "Testing2"

    assert_equal(5, Comment.count)
  end

  test "should not get delete comment for resident" do
    sign_in @resident_user
    get '/comments/' + @comment.id.to_s + '/delete'
    assert_redirected_to root_url
  end

  test "should destroy comment for admin" do
    sign_in @admin_user
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end
  end

  test "should destroy comment for official" do
    sign_in @official_user
    get '/reports/' + @report.id.to_s
    assert_response :success

    @new_comment = Comment.create(user_id: @official_user.id, report_id: @report.id, comment: 'Testing')

    get '/submit_comment?user_id=' + @new_comment.user_id.to_s + '&report_id=' + @new_comment.report_id.to_s + '&comment=' + @new_comment.comment
    get '/reports/' + @report.id.to_s
    assert_select "td#report_comment", text: "Testing"

    assert_difference('Comment.count', -1) do
      delete comment_url(@new_comment)
    end
  end
end
