class UsersController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :set_user, only: %i[ show edit update ]

  # GET /users or /users.json
  def index
    @pagy, @users = pagy(User.all.order(:username), items: 10, size: [1,0,0,1])
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if params[:user][:active] == "true"
        @user.deactivated_at = nil
      else
        @user.deactivated_at = DateTime.current
      end

      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if (User.where(id: params[:id]).present?)
        @user = User.find(params[:id])
      else
        redirect_to users_path
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :address1, :address2, :city, :state, :zip, :phone, :username, :active, :role, :email, :password, :password_confirmation, :deactivated_at) 
    end

    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
        redirect_to url_for(page: exception.pagy.last)
    end
end