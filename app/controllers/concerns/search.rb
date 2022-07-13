module Search
  extend ActiveSupport::Concern

  included do
    
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

end