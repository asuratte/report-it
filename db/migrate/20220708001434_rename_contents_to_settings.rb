class RenameContentsToSettings < ActiveRecord::Migration[6.1]
  def change
    rename_table :contents, :settings
    add_column :settings, :allow_anonymous_reports, :boolean, default: true
  end
end
