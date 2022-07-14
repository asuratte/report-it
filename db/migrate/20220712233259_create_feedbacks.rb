class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :category, null: false
      t.string :comment, null: false, :limit => 200
      t.string :status, default: 'New'
      t.integer :active_status, default: 0

      t.timestamps
    end
  end
end
