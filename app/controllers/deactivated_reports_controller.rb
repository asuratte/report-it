class DeactivatedReportsController < ApplicationController
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page
    rescue_from Pagy::VariableError, with: :redirect_to_last_page
    before_action :get_search_values, only: [:index]

    def index
      @search_submit_path = '/deactivated-reports'

      if params[:commit] == 'Clear Attribute'
        self.set_submit_fields('clear')
        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').where.not(active_status: 0), items: 10, size: [1,0,0,1])

        @reports_cleared = true
        self.set_radio_div('attribute')

      elsif params[:commit] == 'Clear Dates'
        self.set_submit_fields('clear')
        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').where.not(active_status: 0), items: 10, size: [1,0,0,1])

        @reports_cleared = true
        self.set_radio_div('dates')

      elsif params[:commit] == 'Search Dates' && session[:admin_deactivated_start_date].present? && session[:admin_deactivated_end_date].present?
        self.set_submit_fields('dates')
        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').search_dates(session[:admin_deactivated_start_date], session[:admin_deactivated_end_date]).where.not(active_status: 0), items: 10, size: [1,0,0,1])

        @reports_cleared = false
        self.set_radio_div('dates')
      elsif params[:commit] == 'Search Dates' && !session[:admin_deactivated_start_date].present? && !session[:admin_deactivated_end_date].present?
        self.set_submit_fields('dates')

        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').where.not(active_status: 0), items: 10, size: [1,0,0,1])

        @reports_cleared = true
        self.set_radio_div('dates')
      else
        self.set_submit_fields('attribute')
        @pagy, @deactivated_reports = pagy(Report.order('created_at DESC').search(session[:admin_deactivated_search_type], session[:admin_deactivated_search_term]).where.not(active_status: 0), items: 10, size: [1,0,0,1])

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
        @admin_deactivated_search_type = nil
        @admin_deactivated_search_term = nil
        @admin_deactivated_start_date = nil
        @admin_deactivated_end_date = nil
      elsif set_submit_type == 'attribute'
        @admin_deactivated_search_type = session[:admin_deactivated_search_type]
        @admin_deactivated_search_term = session[:admin_deactivated_search_term]
        @admin_deactivated_start_date = nil
        @admin_deactivated_end_date = nil
      elsif set_submit_type == "dates"
        @admin_deactivated_search_type = nil
        @admin_deactivated_search_term = nil
        @admin_deactivated_start_date = session[:admin_deactivated_start_date]
        @admin_deactivated_end_date = session[:admin_deactivated_end_date]
      end
    end

    private
    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
        redirect_to url_for(page: exception.pagy.last)
    end

    # Sets the search type and term for the session using the search parameters
    def get_search_values
      session[:admin_deactivated_search_type] = nil
      session[:admin_deactivated_search_term] = nil
      session[:admin_deactivated_start_date] = nil
      session[:admin_deactivated_end_date] = nil

      if params[:admin_deactivated_search_term]
        session[:admin_deactivated_search_type] = params[:admin_deactivated_search_type]
        session[:admin_deactivated_search_term] = params[:admin_deactivated_search_term]
      end

      if params[:admin_deactivated_start_date] && params[:admin_deactivated_end_date]
        session[:admin_deactivated_start_date] = params[:admin_deactivated_start_date]
        session[:admin_deactivated_end_date] = params[:admin_deactivated_end_date]
      end

      if params[:commit]
        session[:commit] = params[:commit]
      end
    end
end
