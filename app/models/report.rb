class Report < ApplicationRecord
  belongs_to :user
  validates :city, :state, :zip, :description, :category, :subcategory, presence: true
end
