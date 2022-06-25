class RemoveNullConstraintFromReportUser < ActiveRecord::Migration[6.1]
  def change
    change_column_null :reports, :user_id, true
  end
end
