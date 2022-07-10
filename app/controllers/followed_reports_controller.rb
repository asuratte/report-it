class FollowedReportsController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page

  # GET /followed_reports or /followed_reports.json
  def index
    @user = current_user
    @pagy, @followed_reports = pagy(@user.followed_reports.order('created_at DESC').where(active_status: 0), items: 10, size: [1,0,0,1])
  end


  private
    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
      redirect_to url_for(page: exception.pagy.last)
  end
end
