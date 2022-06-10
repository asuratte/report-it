json.extract! user, :id, :created_at, :updated_at, :first_name, :last_name, :address1, :address2, :city, :state, :zip, :phone, :username, :active, :role, :email, :password
json.url user_url(user, format: :json)
