class Setting < ApplicationRecord
    has_one_attached :image, dependent: :destroy
    validates :image, content_type: [:png, :jpg, :jpeg]
    validates :image, size: { between: 1.kilobyte..5.megabytes , message: 'must be between 1 KB and 5 MB' }
end
