namespace :import do
  desc "TODO"
  task csv_model: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "user_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      u = User.new
      u.email = row["email"]
      u.first_name = row["first_name"]
      u.last_name = row["last_name"]
      u.address1 = row["address1"]
      u.address2 = row["address2"]
      u.city = row["city"]
      u.state = row["state"]
      u.zip = row["zip"]
      u.phone = row["phone"]
      u.username = row["username"]
      u.active = row["active"]
      u.role = row["role"]
      u.password = row["password"]
      u.password_confirmation = row["password_confirmation"]
      u.created_at = (rand*30).days.ago
      u.updated_at = (u.created_at + 2.hours) unless row["deactivated_at"].nil?
      u.deactivated_at = (u.created_at + 2.hours) unless row["deactivated_at"].nil?
      u.save
    end

    csv_text = File.read(Rails.root.join("lib", "report_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      r = Report.new
      r.address1 = row["address1"]
      r.address2 = row["address2"]
      r.city = row["city"]
      r.state = row["state"]
      r.zip = row["zip"]
      r.description = row["description"]
      r.category = row["category"]
      r.subcategory = row["subcategory"]
      r.status = row["status"]
      r.severity = row["severity"]
      r.user_id = row["user_id"]
      r.active_status = row["active_status"]
      r.save
      r.created_at = (rand*30).days.ago
      r.updated_at = (r.created_at + 2.hours) unless row["deactivated_at"].nil?
      r.deactivated_at = (r.created_at + 2.hours) unless row["deactivated_at"].nil?
      r.save
    end

    csv_text = File.read(Rails.root.join("lib", "theme_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      t = Theme.new
      t.name = row["name"]
      t.save
    end

    csv_text = File.read(Rails.root.join("lib", "setting_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      c = Setting.new
      c.homepage_heading_1 = row["homepage_heading_1"]
      c.footer_copyright = row["footer_copyright"]
      c.allow_anonymous_reports = row["allow_anonymous_reports"]
      c.save
    end

    csv_text = File.read(Rails.root.join("lib", "category_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      cat = Category.new
      cat.name = row["name"]
      cat.active = row["active"]
      cat.save
    end

    csv_text = File.read(Rails.root.join("lib", "subcategory_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      subcat = Subcategory.new
      subcat.name = row["name"]
      subcat.description = row["description"]
      subcat.category_id = row["category_id"]
      subcat.active = row["active"]
      subcat.save
    end

    csv_text = File.read(Rails.root.join("lib", "comment_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      com = Comment.new
      com.user_id = row["user_id"]
      com.report_id = row["report_id"]
      com.comment = row["comment"]
      com.save
    end

    csv_text = File.read(Rails.root.join("lib", "feedback_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      feed = Feedback.new
      feed.user_id = row["user_id"]
      feed.category = row["category"]
      feed.comment = row["comment"]
      feed.status = row["status"]
      feed.active_status = row["active_status"]
      feed.save
    end

    csv_text = File.read(Rails.root.join("lib", "followed_report_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      fr = FollowedReport.new
      fr.user_id = row["user_id"]
      fr.report_id = row["report_id"]
      fr.save
    end

    csv_text = File.read(Rails.root.join("lib", "confirmation_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      c = Confirmation.new
      c.user_id = row["user_id"]
      c.report_id = row["report_id"]
      c.save
    end

  end
end
