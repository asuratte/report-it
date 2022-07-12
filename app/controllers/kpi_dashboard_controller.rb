class KpiDashboardController < ApplicationController
    def index
        if params[:commit] == 'Choose Dates' && params[:start_date].present? && params[:end_date].present? && params[:start_date] <= params[:end_date]
            @start_date = Date.parse(params[:start_date])
            start_date_beginning_of_day = @start_date.beginning_of_day
            @end_date = Date.parse(params[:end_date])
            end_date_end_of_day = @end_date.end_of_day
            @reports = Report.where(created_at: (start_date_beginning_of_day)..(end_date_end_of_day))
            @invalid_date = false
            @selection_cleared = false
        elsif params[:commit] == 'Choose Dates' && ((!params[:start_date].present? || !params[:end_date].present?) || params[:start_date] > params[:end_date])
            @invalid_date = true
            @selection_cleared = true
        elsif params[:commit] == 'View All Time'
            @reports = Report.all
            @invalid_date = false
        elsif params[:commit] == 'Clear Selection'
            redirect_to kpi_dashboard_path
            @invalid_date = false
            @selection_cleared = true
        else
            @reports = nil
            @start_date = nil
            @end_date = nil
            @invalid_date = false
            @selection_cleared = true
        end
    end
end
