class ThemesController < ApplicationController
  before_action :set_theme, only: %i[ show edit update destroy ]

  # GET /themes or /themes.json
  def index
    @themes = Theme.all
  end

  # GET /themes/1 or /themes/1.json
  def show
  end

  # GET /themes/new
  def new
    @theme = Theme.new
  end

  # GET /themes/1/edit
  def edit
  end

  # POST /themes or /themes.json
  def create
    @theme = Theme.new(theme_params)

    respond_to do |format|
      if @theme.save
        format.html { redirect_to theme_url(@theme), notice: "Theme was successfully created." }
        format.json { render :show, status: :created, location: @theme }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /themes/1 or /themes/1.json
  def update
    respond_to do |format|
      if @theme.update(theme_params)
        format.html { redirect_to theme_url(@theme), notice: "Theme was successfully updated." }
        format.json { render :show, status: :ok, location: @theme }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1 or /themes/1.json
  def destroy
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to themes_url, notice: "Theme was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def theme_params
      params.require(:theme).permit(:logo, :hero, :font_google_css, :font_google_css_url, :font_default_css, :color_header_text, :color_accent, :color_text_dark, :color_text_light, :color_login_bar, :color_header_background, :color_footer_background, :color_button_primary, :color_button_secondary, :color_button_hover, :color_button_text_dark, :color_button_text_light, :color_nav_link, :color_nav_link_hover, :color_page_link, :color_page_link_active, :color_page_background, :color_page_border, :color_table_before, :color_list_even, :color_list_odd, :color_container_link, :color_container_link_hover)
    end
end
