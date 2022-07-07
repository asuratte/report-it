class ReportsByUserController < ApplicationController
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page
    rescue_from Pagy::VariableError, with: :redirect_to_last_page

    def index
        user_id = params[:user_id]
        if (User.where(id: user_id).present?)
            @pagy, @user_reports = pagy(Report.where('user_id = ?', user_id).order('created_at DESC'), items: 10, size: [1,0,0,1])
        else
            redirect_to users_path
        end
    end

    private
    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
        redirect_to url_for(page: exception.pagy.last)
    end
end
