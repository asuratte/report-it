class SettingsRemoveLogoImagePath < ActiveRecord::Migration[6.1]
  def change
    remove_column :settings, :logo_image_path
  end
end
