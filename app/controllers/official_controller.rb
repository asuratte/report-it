class OfficialController < ApplicationController
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page
  rescue_from Pagy::VariableError, with: :redirect_to_last_page
  before_action :authenticate_user!, only: [:index]

  def inititialize
    self.clear_reports_list
    @search_made = false

    @sort = "CASE
    WHEN status = 'New' THEN 1
    WHEN status = 'In Progress' THEN 2
    WHEN status = 'Flagged' THEN 3
    WHEN status = 'Resolved' THEN 4
    ELSE 5 END, created_at DESC"
  end

  def index
    # enum [Status, Severity, Address, City, State, Zip, Description]
    @search_made = true
    if params[:incident].blank? == false
      @pagy, list = pagy(Report.where("id =" + params[:incident]).order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_incident = "selected"
    elsif params[:status].blank? == false
      @pagy, list = pagy(Report.where("lower(status) LIKE ?", "%" + params[:status].downcase + "%").order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_status = "selected"
    elsif params[:severity].blank? == false
      @pagy, list = pagy(Report.where("lower(severity) LIKE ?", "%" + params[:severity].downcase + "%").order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_severity = "selected"
    elsif params[:address].blank? == false
      @pagy, list = pagy(Report.where("lower(address1) LIKE :input OR lower(address2) LIKE :input", :input => ("%" + params[:address].downcase + "%")).order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_address = "selected"
    elsif params[:city].blank? == false
      @pagy, list = pagy(Report.where("lower(city) LIKE ?", "%" + params[:city].downcase + "%").order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_city = "selected"
    elsif params[:state].blank? == false
      @pagy, list = pagy(Report.where("lower(state) LIKE ?", "%" + params[:state].downcase + "%").order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_state = "selected"
    elsif params[:zip].blank? == false
      @pagy, list = pagy(Report.where("lower(zip) LIKE ?", "%" + params[:zip].downcase + "%").order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_zip = "selected"
    elsif params[:description].blank? == false
      @pagy, list = pagy(Report.where("lower(description) LIKE ?", "%" + params[:description].downcase + "%").order(Arel.sql(@sort.to_s)), items: 10, size: [1,0,0,1])
      self.set_reports(list)
      @selected_description = "selected"
    else
      self.clear_reports_list
    end
    self.get_reports
  end

  # clear reports
  def clear_reports_list
    list = Report.where(zip: [nil, ""])
    self.set_reports(list)
    @search_made = false
  end

  # GET /reports
  def get_reports
    return @reports
  end

  # SET /reports
  def set_reports(list)
    @reports = list
  end

  private

  # Redirects to the last page when exception thrown
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last)
  end
end
