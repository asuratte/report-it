class AddDescriptionToSubcategory < ActiveRecord::Migration[6.1]
  def change
    add_column :subcategories, :description, :text
  end
end
