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
      r.save
      r.created_at = (rand*30).days.ago
      r.save
    end

    csv_text = File.read(Rails.root.join("lib", "theme_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      t = Theme.new
      t.name = row["name"]
      t.save
    end

    csv_text = File.read(Rails.root.join("lib", "content_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      c = Content.new
      c.homepage_heading_1 = row["homepage_heading_1"]
      c.logo_image_path = row["logo_image_path"]
      c.footer_copyright = row["footer_copyright"]
      c.save
    end

  end
end