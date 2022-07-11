class KpiDashboardController < ApplicationController
    def index
        if params[:start_date].present? && params[:end_date].present?
            @start_date = Date.parse(params[:start_date])
            start_date_beginning_of_day = @start_date.beginning_of_day
            @end_date = Date.parse(params[:end_date])
            end_date_end_of_day = @end_date.end_of_day
            puts @start_date
            puts @end_date
            @reports = Report.where(created_at: (start_date_beginning_of_day)..(end_date_end_of_day))
        else
            @reports = nil
            @start_date = nil
            @end_date = nil
        end
    end
end
