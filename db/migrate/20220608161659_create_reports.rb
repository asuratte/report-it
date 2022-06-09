class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :address1
      t.string :address2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.text :description, null: false
      t.string :category
      t.string :subcategory
      t.string :status, default: 'New'
      t.string :severity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
