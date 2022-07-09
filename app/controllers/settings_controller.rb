class SettingsController < ApplicationController
  before_action :set_setting, only: %i[ show edit update destroy ]

  # GET /settings or /settings.json
  def index
    @settings = Setting.all
  end

  # GET /settings/1 or /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings or /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to setting_url(@setting), notice: "setting was successfully created." }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1 or /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to setting_url(@setting), notice: "setting was successfully updated." }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1 or /settings/1.json
  def destroy
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to settings_url, notice: "setting was successfully destroyed." }
      format.json { head :no_setting }
    end
  end

  def delete_image
    image = ActiveStorage::Attachment.find(params[:image_id])
    setting = image.record
    if current_user.admin?
      image.purge
      redirect_to edit_setting_path(setting)
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.require(:setting).permit(:homepage_heading_1, :footer_copyright, :allow_anonymous_reports, :image)
    end
end
