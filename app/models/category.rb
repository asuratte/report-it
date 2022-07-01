class Category < ApplicationRecord
    has_many :subcategory
    validates :name, presence: true

    def self.get_active_categories
        self.all.where(:active => true)
    end

end
