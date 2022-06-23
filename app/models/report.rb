class Report < ApplicationRecord
  belongs_to :user
  enum active_status: [:active, :spam, :abuse, :outside_area]

  validates :city, :state, :zip, :description, :category, :subcategory, presence: true
  validates :address1, :address2, :city, :state, length: { maximum: 50 }
  validates :description, length: {maximum: 1000}
  validates_format_of :zip, :with => /\A\d{5}(-\d{4})?\z/, :message => "should be a valid US zip code. ex: 12345 or 12345-1234"

  def is_active?
      return self.active_status == 'active' ? true : false
  end

end