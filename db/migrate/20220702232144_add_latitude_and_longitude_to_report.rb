class AddLatitudeAndLongitudeToReport < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :latitude, :decimal
    add_column :reports, :longitude, :decimal
  end
end
