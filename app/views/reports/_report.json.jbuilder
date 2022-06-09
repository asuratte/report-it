json.extract! report, :id, :address1, :address2, :city, :state, :zip, :description, :category, :subcategory, :status, :severity, :user_id, :created_at, :updated_at
json.url report_url(report, format: :json)
