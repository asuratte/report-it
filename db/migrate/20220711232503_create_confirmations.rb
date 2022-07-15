class CreateConfirmations < ActiveRecord::Migration[6.1]
  def change
    create_table :confirmations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
