class KpiDashboardController < ApplicationController
    def index
        @reports = Report.all
    end
end
