class Theme < ApplicationRecord
  validates :element, :value, presence: true
end
