class AddActiveStatusToReport < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :active_status, :integer, default: 0
  end
end
