class FeedbacksController < ApplicationController
  include Search
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!
  before_action :set_feedback, only: %i[ show edit update ]
  before_action :allow_feedback_access, only: %i[ show edit update ]

  # GET /feedbacks or /feedbacks.json
  def index
    @search_page = :feedback
    get_search_values @search_page
    get_search_categories @search_page
    @search_submit_path = feedbacks_path

    if params[:commit] == 'Clear'
      self.set_submit_fields('clear', @search_page)
      @pagy, @feedbacks = pagy(Feedback.joins(:user).select("feedbacks.id, feedbacks.user_id, users.username, feedbacks.comment, feedbacks.status, feedbacks.category, feedbacks.active_status, feedbacks.created_at").order(Arel.sql("CASE
        WHEN status = 'New' THEN 1
        WHEN status = 'In Progress' THEN 2
        WHEN status = 'Flagged' THEN 3
        WHEN status = 'Resolved' THEN 4
        ELSE 5 END, created_at DESC")).where(active_status: 0), items: 10, size: [1,0,0,1])
    elsif params[:commit] == 'Search Dates'
      self.set_submit_fields('dates', @search_page)
      @pagy, @feedbacks = pagy(Feedback.joins(:user).select("feedbacks.id, feedbacks.user_id, users.username, feedbacks.comment, feedbacks.status, feedbacks.category, feedbacks.active_status, feedbacks.created_at").order('feedbacks.created_at DESC').search_dates(session[:feedback_start_date], session[:feedback_end_date]).where(active_status: 0), items: 10, size: [1,0,0,1])
    else
      self.set_submit_fields('attribute', @search_page)
      @pagy, @feedbacks = pagy(Feedback.joins(:user).select("feedbacks.id, feedbacks.user_id, users.username, feedbacks.comment, feedbacks.status, feedbacks.category, feedbacks.active_status, feedbacks.created_at").order(Arel.sql("CASE
        WHEN status = 'New' THEN 1
        WHEN status = 'In Progress' THEN 2
        WHEN status = 'Flagged' THEN 3
        WHEN status = 'Resolved' THEN 4
        ELSE 5 END, created_at DESC")).search(session[:feedback_search_type], session[:feedback_search_term]).where(active_status: 0), items: 10, size: [1,0,0,1])
    end

    session[:feedback_search_radio_value] == 'Dates' ? self.set_radio_div('dates') : self.set_radio_div('attribute')
  end

  # GET /feedbacks/1 or /feedbacks/1.json
  def show
    @username = User.get_username(@feedback.user_id).username

    unless @feedback.user_id == current_user.id || current_user.is_official? || current_user.is_admin?
      redirect_to root_path
    end
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
    @username = User.get_username(@feedback.user_id).username
  end

  # POST /feedbacks or /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user_id = current_user.id if current_user

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to feedback_url(@feedback), notice: "Feedback was successfully created." }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1 or /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to feedback_url(@feedback), notice: "Feedback was successfully updated." }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1 or /feedbacks/1.json
  def destroy
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: "Feedback was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def feedback_params
      params.require(:feedback).permit(:user_id, :category, :comment, :status, :active_status)
    end

    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
      redirect_to url_for(page: exception.pagy.last)
    end

    def allow_feedback_access
      unless @feedback.user_id == current_user.id || current_user.is_official? || current_user.is_admin?
        redirect_to root_path
      end
    end
end
