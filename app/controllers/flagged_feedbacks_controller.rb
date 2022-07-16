class FlaggedFeedbacksController < ApplicationController
  include Search
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page

  def index
    @search_page = :admin_flagged_feedback
    get_search_values @search_page
    get_search_categories @search_page
    @search_submit_path = flagged_feedbacks_path

    if params[:commit] == 'Clear'
      self.set_submit_fields('clear', @search_page)
      @pagy, @flagged_feedbacks = pagy(Feedback.joins(:user).select("feedbacks.id, feedbacks.user_id, users.username, feedbacks.comment, feedbacks.status, feedbacks.category, feedbacks.active_status, feedbacks.created_at").order('created_at DESC').where(status: "Flagged", active_status: 0), items: 10, size: [1,0,0,1])
    elsif params[:commit] == 'Search Dates'
      self.set_submit_fields('dates', @search_page)
      @pagy, @flagged_feedbacks = pagy(Feedback.joins(:user).select("feedbacks.id, feedbacks.user_id, users.username, feedbacks.comment, feedbacks.status, feedbacks.category, feedbacks.active_status, feedbacks.created_at").order('created_at DESC').feedback_search_dates(session[:admin_flagged_feedback_start_date], session[:admin_flagged_feedback_end_date]).where(status: "Flagged", active_status: 0), items: 10, size: [1,0,0,1])
    else
      self.set_submit_fields('attribute', @search_page)
      @pagy, @flagged_feedbacks = pagy(Feedback.joins(:user).select("feedbacks.id, feedbacks.user_id, users.username, feedbacks.comment, feedbacks.status, feedbacks.category, feedbacks.active_status, feedbacks.created_at").order('created_at DESC').feedback_search(session[:admin_flagged_feedback_search_type], session[:admin_flagged_feedback_search_term]).where(status: "Flagged", active_status: 0), items: 10, size: [1,0,0,1])
    end

    session[:admin_flagged_feedback_search_radio_value] == 'Dates' ? self.set_radio_div('dates') : self.set_radio_div('attribute')
  end

  private
  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
      redirect_to url_for(page: exception.pagy.last)
  end
end
