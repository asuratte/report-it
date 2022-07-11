class CreateFollowedReports < ActiveRecord::Migration[6.1]
  def change
    create_table :followed_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
