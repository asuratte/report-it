class ReportsController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :allow_report_access, only: %i[ edit update destroy ]
  before_action :get_search_values, only: [:index]

  # GET /reports or /reports.json
  def index
    @form_submit_path = reports_path
    @resident_search_type = session[:resident_search_type]
    @resident_search_term = session[:resident_search_term]
    @pagy, @reports = pagy(Report.order('created_at DESC').search(session[:resident_search_type], session[:resident_search_term]).where(active_status: 0), items: 10, size: [1,0,0,1])
  end

  # GET /reports/1 or /reports/1.json
  def show
    if @report.active_status != "active" && (current_user == nil || current_user.is_resident? || current_user.is_official?)
      redirect_to reports_path
    end
  end

  # GET /reports/new
  def new
    if params[:category] && params[:subcategory]
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
      if params[:resident_search_term]
        session[:resident_search_type] = params[:resident_search_type]
        session[:resident_search_term] = params[:resident_search_term]
      end
    end
end
