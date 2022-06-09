class Report < ApplicationRecord
  belongs_to :user
  validates :city, :state, :zip, :description, :category, :subcategory, presence: true
  validates :address1, :address2, :city, :state, length: { maximum: 50 }
  validates :zip, length: { is: 5 }
  validates :description, length: {maximum: 1000}
end
