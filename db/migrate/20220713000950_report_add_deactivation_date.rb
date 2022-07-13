class ReportAddDeactivationDate < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :deactivated_at, :datetime
  end
end
