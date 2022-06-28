class Subcategory < ApplicationRecord
  belongs_to :category, :optional => true

  def self.get_subcategories_by_category(category)
    self.all.where(:category_id => category.id)
  end

end
