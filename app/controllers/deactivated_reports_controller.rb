class DeactivatedReportsController < ApplicationController
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page
    rescue_from Pagy::VariableError, with: :redirect_to_last_page

    def index
        @pagy, @deactivated_reports = pagy(Report.all.where.not(active_status: 0).order('created_at DESC'), items: 10, size: [1,0,0,1])
    end
end
