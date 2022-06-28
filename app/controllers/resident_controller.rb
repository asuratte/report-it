class ResidentController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!, only: [:index]
  
  def index
    @user = current_user
    @categories = Category.all.order(:id)
    @pagy, @reports = pagy(@user.reports.where(active_status: 0).order('created_at DESC'), items: 7, size: [1,0,0,1])
  end

  private

  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last)
  end
end
