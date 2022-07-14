class KpiDashboardController < ApplicationController
    def index
        if params[:commit] == 'Choose Dates' && params[:start_date].present? && params[:end_date].present? && params[:start_date] <= params[:end_date]
            @start_date = Date.parse(params[:start_date])
            start_date_beginning_of_day = @start_date.beginning_of_day
            @end_date = Date.parse(params[:end_date])
            end_date_end_of_day = @end_date.end_of_day
            @new_reports = Report.where(created_at: (start_date_beginning_of_day)..(end_date_end_of_day))
            @deactivated_reports = Report.where(deactivated_at: (start_date_beginning_of_day)..(end_date_end_of_day)).where.not(deactivated_at: nil)
            @users = User.all.where(created_at: (start_date_beginning_of_day)..(end_date_end_of_day))
            @invalid_date = false
            @selection_cleared = false
            @all_time = false
        elsif params[:commit] == 'Choose Dates' && ((!params[:start_date].present? || !params[:end_date].present?) || params[:start_date] > params[:end_date])
            @invalid_date = true
            @selection_cleared = true
            @all_time = false
        elsif params[:commit] == 'View All Time'
            @new_reports = Report.all
            @deactivated_reports = Report.all.where.not(deactivated_at: nil)
            @users = User.all.where(created_at: (start_date_beginning_of_day)..(end_date_end_of_day))
            @invalid_date = false
            @selection_cleared = false
            @all_time = true
        elsif params[:commit] == 'Clear Selection'
            redirect_to kpi_dashboard_path
            @invalid_date = false
            @selection_cleared = true
            @all_time = false
        else
            @new_reports = nil
            @start_date = nil
            @end_date = nil
            @invalid_date = false
            @selection_cleared = true
            @all_time = false
        end
    end
end