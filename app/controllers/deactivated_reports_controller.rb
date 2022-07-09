class DeactivatedReportsController < ApplicationController
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page
    rescue_from Pagy::VariableError, with: :redirect_to_last_page
    before_action :get_search_values, only: [:index]

    def index
      @search_submit_path = '/deactivated-reports'

      if params[:submit] == 'Clear'
        @admin_deactivated_search_type = nil
        @admin_deactivated_search_term = nil
        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').where.not(active_status: 0), items: 10, size: [1,0,0,1])

        @reports_cleared = true
      else
        @admin_deactivated_search_type = session[:admin_deactivated_search_type]
        @admin_deactivated_search_term = session[:admin_deactivated_search_term]
        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').search(session[:admin_deactivated_search_type], session[:admin_deactivated_search_term]).where.not(active_status: 0), items: 10, size: [1,0,0,1])

        @reports_cleared = false
      end
    end

    private
    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
        redirect_to url_for(page: exception.pagy.last)
    end

    # Sets the search type and term for the session using the search parameters
    def get_search_values
      if params[:admin_deactivated_search_term]
        session[:admin_deactivated_search_type] = params[:admin_deactivated_search_type]
        session[:admin_deactivated_search_term] = params[:admin_deactivated_search_term]
      end
    end
end
