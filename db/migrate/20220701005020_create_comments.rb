class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :report_id
      t.string :comment, :limit => 200

      t.timestamps
    end
  end
end
