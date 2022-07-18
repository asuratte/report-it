class Comment < ApplicationRecord
  belongs_to :report
  belongs_to :user

  validates :comment, presence: true
  validates :comment, length: { maximum: 200 }
end
