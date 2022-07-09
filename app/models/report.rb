class Report < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :image, dependent: :destroy
  enum active_status: [:active, :spam, :abuse, :outside_area]
  geocoded_by :address
  after_validation :geocode

  validates :city, :state, :zip, :description, :category, :subcategory, presence: true
  validates :address1, :address2, :city, :state, length: { maximum: 50 }
  validates :description, length: {maximum: 1000}
  validates_format_of :zip, :with => /\A\d{5}(-\d{4})?\z/, :message => "should be a valid US zip code. ex: 12345 or 12345-1234"
  validates :image, content_type: [:png, :jpg, :jpeg]
  validates :image, size: { between: 1.kilobyte..5.megabytes , message: 'must be between 1 KB and 5 MB' }
  has_many :comments

  def is_active?
      return self.active_status == 'active' ? true : false
  end

  # Searches for reports by incident no, address, city, state, zip or description
  def self.search(search_type, search_term)
    report = Report.all
    if search_type == "Incident No." && search_term.present?
      if Integer(search_term, exception: false)
        report = report.where("id =" + search_term)
      else
        report = report.none
      end
    elsif search_type == "Status" && search_term.present?
      report = report.where("lower(status) LIKE ?", "%#{search_term.downcase}%")
    elsif search_type == "Severity" && search_term.present?
      report = report.where("lower(severity) LIKE ?", "%#{search_term.downcase}%")
    elsif search_type == "Category" && search_term.present?
      report = report.where("lower(category) LIKE :search_term OR lower(subcategory) LIKE :search_term", search_term: "%#{search_term.downcase}%")
    elsif search_type == "Address" && search_term.present?
      report = report.where("lower(address1) LIKE :search_term OR lower(address2) LIKE :search_term", search_term: "%#{search_term.downcase}%")
    elsif search_type == "City" && search_term.present?
      report = report.where("lower(city) LIKE ?", "%#{search_term.downcase}%")
    elsif search_type == "State" && search_term.present?
      report = report.where("lower(state) LIKE ?", "%#{search_term.downcase}%")
    elsif search_type == "Zip" && search_term.present?
      report = report.where("zip LIKE ?", "%#{search_term}%")
    elsif search_type == "Description" && search_term.present?
      report = report.where("lower(description) LIKE ?", "%#{search_term.downcase}%")
    end
    return report
  end

  # Searches for reports by incident no, address, city, state, zip or description
  def self.search_dates(start_date, end_date)
    report = Report.all
    if start_date.present? && end_date.present?
      report = report.where("DATE(created_at) >= ? AND DATE(created_at) <= ?", "%#{start_date}%", "%#{end_date}%")
    end
    return report
  end

  def address
    [address1, address2, city, state, zip].compact.join(', ')
  end

  def google_map
    "https://maps.googleapis.com/maps/api/staticmap?zoom=17&size=400x300&markers=size:small%7Ccolor:red%7C#{latitude},#{longitude}&key=#{Rails.application.credentials.google_maps_api_key}"
  end

end
