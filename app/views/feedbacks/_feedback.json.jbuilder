json.extract! feedback, :id, :user_id, :category, :comment, :status, :active_status, :created_at, :updated_at
json.url feedback_url(feedback, format: :json)
