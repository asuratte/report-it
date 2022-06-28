class Category < ApplicationRecord
    has_many :subcategory

    def self.get_active_categories
        self.all.where(:active => true)
    end

end
