class FlaggedReportsController < ApplicationController
  include Search
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page

  def index
    @search_page = :admin_flagged
    get_search_values @search_page
    get_search_categories @search_page
    @search_submit_path = flagged_reports_path

    if params[:commit] == 'Clear'
      self.set_submit_fields('clear', @search_page)
      @pagy, @flagged_reports = pagy(Report.order('created_at DESC').where(status: "Flagged", active_status: "active"), items: 10, size: [1,0,0,1])
    elsif params[:commit] == 'Search Dates'
      self.set_submit_fields('dates', @search_page)
      @pagy, @flagged_reports = pagy(Report.order('created_at DESC').search_dates(session[:admin_flagged_start_date], session[:admin_flagged_end_date]).where(status: "Flagged", active_status: "active"), items: 10, size: [1,0,0,1])
    else
      self.set_submit_fields('attribute', @search_page)
      @pagy, @flagged_reports = pagy(Report.order('created_at DESC').search(session[:admin_flagged_search_type], session[:admin_flagged_search_term]).where(status: "Flagged", active_status: "active"), items: 10, size: [1,0,0,1])
    end

    params[:search_radio_value] == 'Attribute' ? self.set_radio_div('attribute') : self.set_radio_div('dates')
  end

  private
  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
      redirect_to url_for(page: exception.pagy.last)
  end

end
