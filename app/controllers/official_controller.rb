class OfficialController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!, only: [:index]

  def index
    @pagy, @reports = pagy(Report.order(Arel.sql(
      "CASE 
      WHEN status = 'New' THEN 1 
      WHEN status = 'In Progress' THEN 2 
      WHEN status = 'Flagged' THEN 3 
      WHEN status = 'Resolved' THEN 4 
      ELSE 5 END, created_at DESC"
      )), items: 10, size: [1,1,1,1])
  end

  private

  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last)
  end
end
