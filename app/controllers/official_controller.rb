class OfficialController < ApplicationController
  include Search
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!, only: [:index]

  def index
    @search_page = :official
    get_search_values @search_page
    get_search_categories @search_page
    @search_submit_path = official_search_path

    if params[:commit] == 'Clear'
      self.set_submit_fields('clear', @search_page)
      @pagy, @official_reports = pagy(Report.order(Arel.sql("CASE
        WHEN status = 'New' THEN 1
        WHEN status = 'In Progress' THEN 2
        WHEN status = 'Flagged' THEN 3
        WHEN status = 'Resolved' THEN 4
        ELSE 5 END, created_at DESC")).where(active_status: 0), items: 10, size: [1,0,0,1])
    elsif params[:commit] == 'Search Dates' && params[:official_start_date].present? && params[:official_end_date].present? && params[:official_start_date] <= params[:official_end_date]
      self.set_submit_fields('dates', @search_page)
      @pagy, @official_reports = pagy(Report.order('created_at DESC').search_dates(session[:official_start_date], session[:official_end_date]).where(active_status: 0), items: 10, size: [1,0,0,1])
    elsif params[:commit] == 'Search Dates' && ((!params[:official_start_date].present? || !params[:official_end_date].present?) || params[:official_start_date] > params[:official_end_date])
      @invalid_date = true
    else
      self.set_submit_fields('attribute', @search_page)
      @pagy, @official_reports = pagy(Report.order(Arel.sql("CASE
        WHEN status = 'New' THEN 1
        WHEN status = 'In Progress' THEN 2
        WHEN status = 'Flagged' THEN 3
        WHEN status = 'Resolved' THEN 4
        ELSE 5 END, created_at DESC")).search(session[:official_search_type], session[:official_search_term]).where(active_status: 0), items: 10, size: [1,0,0,1])
    end

    session[:official_search_radio_value] == 'Dates' ? self.set_radio_div('dates') : self.set_radio_div('attribute')
  end

  private

  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last)
  end
end
