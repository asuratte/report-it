class ResidentController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def index
    @user = current_user
    @reports = @user.reports.order('created_at DESC')
  end
end
