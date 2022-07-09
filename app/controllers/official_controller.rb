class OfficialController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!, only: [:index]
  before_action :get_search_values, only: [:index]

  def index
    @search_submit_path = '/official-search'

    if session[:official_search_term].nil? || params[:commit] == 'Clear Attribute'
      self.clear_reports_list

      @reports_cleared = true
      self.set_radio_div('attribute')
    elsif session[:official_search_term].nil? || params[:commit] == 'Clear Dates'
      self.clear_reports_list

      @reports_cleared = true
      self.set_radio_div('dates')
    elsif params[:commit] == 'Search Dates' && session[:official_start_date].present? && session[:official_end_date].present?
      self.set_submit_fields('dates')
      @pagy, @reports = pagy(Report.order('created_at DESC').search_dates(session[:official_start_date], session[:official_end_date]).where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = false
      self.set_radio_div('dates')
    else
      self.set_submit_fields('attribute')
      @pagy, @reports = pagy(Report.order(Arel.sql("CASE
        WHEN status = 'New' THEN 1
        WHEN status = 'In Progress' THEN 2
        WHEN status = 'Flagged' THEN 3
        WHEN status = 'Resolved' THEN 4
        ELSE 5 END, created_at DESC")).search(session[:official_search_type], session[:official_search_term]).where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = false
      self.set_radio_div('attribute')
    end
  end

  def set_radio_div(set_radio_type)
    if set_radio_type == 'attribute'
      @radio_checked_dates = ""
      @display_form_dates = "display: none;"

      @radio_checked_attribute = "checked"
      @display_form_attribute = "display: block;"
    elsif set_radio_type == 'dates'
      @radio_checked_dates = "checked"
      @display_form_dates = "display: block;"

      @radio_checked_attribute = ""
      @display_form_attribute = "display: none;"
    end
  end

  def set_submit_fields(set_submit_type)
    if set_submit_type == 'clear'
      @official_search_type = nil
      @official_search_term = nil
      @official_start_date = nil
      @official_end_date = nil
    elsif set_submit_type == 'attribute'
      @official_search_type = session[:official_search_type]
      @official_search_term = session[:official_search_term]
      @official_start_date = nil
      @official_end_date = nil
    elsif set_submit_type == "dates"
      @official_search_type = nil
      @official_search_term = nil
      @official_start_date = session[:official_start_date]
      @official_end_date = session[:official_end_date]
    end
  end

  # clear reports
  def clear_reports_list
    @reports = Report.where(id: 0)
  end

  private

  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last)
  end

  # Sets the search type and term for the session using the search parameters
  def get_search_values
    if params[:official_search_term]
      session[:official_search_type] = params[:official_search_type]
      session[:official_search_term] = params[:official_search_term]
    end

    if params[:official_start_date] && params[:official_end_date]
      session[:official_start_date] = params[:official_start_date]
      session[:official_end_date] = params[:official_end_date]
    end

    if params[:commit]
      session[:commit] = params[:commit]
    end
  end
end
