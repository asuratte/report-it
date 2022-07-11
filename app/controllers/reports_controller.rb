class ReportsController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :allow_report_access, only: %i[ edit update destroy ]
  before_action :get_search_values, only: [:index]

  # GET /reports or /reports.json
  def index
    @search_submit_path = reports_path

    if params[:commit] == 'Clear Attribute'
      self.set_submit_fields('clear')
      @pagy, @reports = pagy(Report.order('created_at DESC').where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = true
      self.set_radio_div('attribute')

    elsif params[:commit] == 'Clear Dates'
      self.set_submit_fields('clear')
      @pagy, @reports = pagy(Report.order('created_at DESC').where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = true
      self.set_radio_div('dates')

    elsif params[:commit] == 'Search Dates' && session[:resident_start_date].present? && session[:resident_end_date].present?
      self.set_submit_fields('dates')
      @pagy, @reports = pagy(Report.order('created_at DESC').search_dates(session[:resident_start_date], session[:resident_end_date]).where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = false
      self.set_radio_div('dates')
    elsif params[:commit] == 'Search Dates' && !session[:resident_start_date].present? && !session[:resident_end_date].present?
      self.set_submit_fields('dates')

      @pagy, @reports = pagy(Report.order('created_at DESC').where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = true
      self.set_radio_div('dates')
    else
      self.set_submit_fields('attribute')
      @pagy, @reports = pagy(Report.order('created_at DESC').search(session[:resident_search_type], session[:resident_search_term]).where(active_status: 0), items: 10, size: [1,0,0,1])

      @reports_cleared = false
      self.set_radio_div('attribute')
    end
  end

  def set_radio_div(set_radio_type)
    if set_radio_type == 'attribute'
      @radio_checked_dates = ""
      @display_form_dates = "display: none;"

      @radio_checked_attribute = "checked"
      @display_form_attribute = "display: block;"
    elsif set_radio_type == 'dates'
      @radio_checked_dates = "checked"
      @display_form_dates = "display: block;"

      @radio_checked_attribute = ""
      @display_form_attribute = "display: none;"
    end
  end

  def set_submit_fields(set_submit_type)
    if set_submit_type == 'clear'
      @resident_search_type = nil
      @resident_search_term = nil
      @resident_start_date = nil
      @resident_end_date = nil
    elsif set_submit_type == 'attribute'
      @resident_search_type = session[:resident_search_type]
      @resident_search_term = session[:resident_search_term]
      @resident_start_date = nil
      @resident_end_date = nil
    elsif set_submit_type == "dates"
      @resident_search_type = nil
      @resident_search_term = nil
      @resident_start_date = session[:resident_start_date]
      @resident_end_date = session[:resident_end_date]
    end
  end

  # GET /reports/1 or /reports/1.json
  def show
    @pagy, @report_comments = pagy(Comment.joins(:user).select("comments.id, comments.user_id, users.username, comments.comment, comments.created_at").where("comments.report_id = " + params[:id].to_s).order("comments.created_at DESC"), items: 5, size: [1,0,0,1])

    if @report.active_status != "active" && (current_user == nil || current_user.is_resident? || current_user.is_official?)
      redirect_to reports_path
    end
  end

  # GET /reports/new
  def new
    if params[:category] && params[:subcategory] && Category.get_active_categories.any?{|category| category.name == params[:category]} && Subcategory.get_active_subcategories.any?{|subcategory| subcategory.name == params[:subcategory]}
      @report = Report.new
      @report.category = params[:category]
      @report.subcategory = params[:subcategory]
    else
      redirect_to resident_path
    end
  end

  # GET /reports/1/edit
  def edit
    if current_user.is_resident? && (@report.status != "New" || @report.active_status != "active")
      redirect_to reports_path
    end
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)
    unless params[:hidden_user] == "true"
      @report.user_id = current_user.id
    end
    respond_to do |format|
      if @report.save
        format.html { redirect_to resident_path, notice: "Report was successfully created." }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: "Report was successfully updated." }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_image
    image = ActiveStorage::Attachment.find(params[:image_id])
    report = image.record
    if current_user.id == report.user_id || current_user.admin?
      image.purge
      redirect_to edit_report_path(report)
    else
      redirect_to root_path
    end
  end

  # Calls the current user's follow method and redirects to the current report page
  def follow
    @report = Report.find(params[:id])
    current_user.follow(@report)
    if current_user.has_followed?(@report)
      redirect_to report_url(@report), notice: "Report was successfully followed."
    else
      redirect_to report_url(@report), notice: "Report was successfully unfollowed."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:address1, :address2, :city, :state, :zip, :description, :category, :subcategory, :status, :severity, :image, :active_status)
    end

    # Redirects to the last page when exception thrown
    def redirect_to_last_page(exception)
      redirect_to url_for(page: exception.pagy.last)
    end

    def allow_report_access
      unless @report.user_id == current_user.id || current_user.is_official? || current_user.is_admin?
        redirect_to root_path
      end
    end

    # Sets the search type and term for the session using the search parameters
    def get_search_values
      session[:resident_search_type] = nil
      session[:resident_search_term] = nil
      session[:resident_start_date] = nil
      session[:resident_end_date] = nil

      if params[:resident_search_term]
        session[:resident_search_type] = params[:resident_search_type]
        session[:resident_search_term] = params[:resident_search_term]
      end

      if params[:resident_start_date] && params[:resident_end_date]
        session[:resident_start_date] = params[:resident_start_date]
        session[:resident_end_date] = params[:resident_end_date]
      end

      if params[:commit]
        session[:commit] = params[:commit]
      end
    end
end
