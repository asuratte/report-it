class Report < ApplicationRecord
  belongs_to :user
  validates :city, :state, :zipcode, :description, :category, :subcategory, :status, presence: true
end
