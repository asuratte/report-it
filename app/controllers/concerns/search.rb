module Search
  extend ActiveSupport::Concern

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

  # Gets the search type and term for the session using the search parameters
  def get_search_values(search_page)
    session["#{search_page}_search_type".to_sym] = nil
    session["#{search_page}_search_term".to_sym] = nil
    session["#{search_page}_start_date".to_sym] = nil
    session["#{search_page}_end_date".to_sym] = nil

    if params["#{search_page}_search_term".to_sym] || (params["#{search_page}_start_date".to_sym] && params["#{search_page}_end_date".to_sym])
      session["#{search_page}_search_type".to_sym] = params["#{search_page}_search_type".to_sym]
      session["#{search_page}_search_term".to_sym] = params["#{search_page}_search_term".to_sym]
      session["#{search_page}_start_date".to_sym] = params["#{search_page}_start_date".to_sym]
      session["#{search_page}_end_date".to_sym] = params["#{search_page}_end_date".to_sym]
      session["#{search_page}_search_radio_value".to_sym] = params["#{search_page}_search_radio_value".to_sym]
    end
  end

  def set_submit_fields(set_submit_type, search_page)
    if set_submit_type == 'clear'
      @search_type_value = nil
      @search_term_value = nil
      @start_date = nil
      @end_date = nil
    elsif set_submit_type == 'attribute'
      @search_type_value = session["#{search_page}_search_type".to_sym]
      @search_term_value = session["#{search_page}_search_term".to_sym]
      @start_date = nil
      @end_date = nil
    elsif set_submit_type == "dates"
      @search_type_value = nil
      @search_term_value = nil
      @start_date = session["#{search_page}_start_date".to_sym]
      @end_date = session["#{search_page}_end_date".to_sym]
    end
  end

  def get_search_categories(search_page)
    if search_page == :official
      @search_categories = ["Incident No.", "Status", "Severity", "Category", "Address", "City", "State", "Zip", "Description"]
    else
      @search_categories = ["Incident No.", "Category", "Address", "City", "State", "Zip", "Description"]
    end
  end

end