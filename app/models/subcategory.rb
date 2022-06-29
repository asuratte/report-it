class Subcategory < ApplicationRecord
  belongs_to :category, :optional => true

  def self.get_active_subcategories
    self.all.where(:active => true)
  end

  def self.get_active_subcategories_by_category(category)
    self.all.where(:category_id => category.id, :active => true)
  end

end
