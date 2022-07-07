class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :check_user, only: [:edit, :create, :delete, :update, :new]

  def check_user
    #restrict resident from comments
    if current_user.is_resident?
      redirect_to root_path, error: 'You are not allowed to access this part of the site'
    end
  end

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # post comment to database
  def submit_comment
    @comment_string = params[:comment]
    @report_id = params[:report_id]
    @report = Report.find(@report_id)
    @user_id = current_user.id

    @comment = Comment.create!(user_id: @user_id, report_id: @report_id, comment: @comment_string)

    respond_to do |format|
      format.html { redirect_to report_path(@report), notice: "Your comment was logged" }
    end
  end

  # GET /comments/1 or /comments/1.json
  def show
    @username = User.get_username(@comment.user_id).username
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @username = User.get_username(@comment.user_id).username
    @check = Comment.find(params[:id])
    #add logic to allow admin or official creator to edit
    if @check.blank? == false && (current_user.id == @check.user_id || current_user.is_admin?)
    else
      redirect_to root_path
    end
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    @check = Comment.find(params[:id])
    #add logic to allow admin or official creator to update
    if current_user.id == @check.user_id || current_user.is_admin?
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to report_path(@check.report_id), notice: "Comment was successfully updated." }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to report_path(@check.report_id)
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @check = Comment.find(params[:id])
    #add logic to allow admin or official creator to delete
    if current_user.id == @check.user_id || current_user.is_admin?
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to report_path(@check.report_id), notice: "Comment was successfully deleted." }
        format.json { head :no_content }
      end
    else
      redirect_to report_path(@check.report_id)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:user_id, :report_id, :comment)
    end
end
