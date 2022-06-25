class FlaggedReportsController < ApplicationController
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page
    rescue_from Pagy::VariableError, with: :redirect_to_last_page

    def index
        @pagy, @flagged_reports = pagy(Report.all.where(status: "Flagged", active_status: "active").order('created_at DESC'), items: 10, size: [1,0,0,1])
    end

    private
    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
        redirect_to url_for(page: exception.pagy.last)
    end

end
