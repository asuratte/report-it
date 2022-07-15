json.extract! followed_report, :id, :user_id, :report_id, :created_at, :updated_at
json.url followed_report_url(followed_report, format: :json)
