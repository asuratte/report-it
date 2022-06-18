class SetDefaultValueReportSeverity < ActiveRecord::Migration[6.1]
  def change
    change_column_default :reports, :severity, "Not Set"
  end
end
