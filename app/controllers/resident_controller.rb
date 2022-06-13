class ResidentController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def index
    @user = current_user
    @pagy, @reports = pagy(@user.reports.order('created_at DESC'), items: 7)
  end
end
