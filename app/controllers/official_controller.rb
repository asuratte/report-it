class OfficialController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!, only: [:index]
  before_action :get_search_values, only: [:index]

  def index
    @search_submit_path = '/official-search'

    if session[:official_search_term].nil? || params[:submit] == 'Clear'
      self.clear_reports_list

      @reports_cleared = true
    else
      @official_search_type = session[:official_search_type]
      @official_search_term = session[:official_search_term]
      @pagy, @reports = pagy(Report.order(Arel.sql("CASE
        WHEN status = 'New' THEN 1
        WHEN status = 'In Progress' THEN 2
        WHEN status = 'Flagged' THEN 3
        WHEN status = 'Resolved' THEN 4
        ELSE 5 END, created_at DESC")).search(session[:official_search_type], session[:official_search_term]).where(active_status: 0), items: 10, size: [1,0,0,1])

        if @official_search_term.nil? == false
          @reports_cleared = false
        else
          @reports_cleared = true
        end
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
  end
end
