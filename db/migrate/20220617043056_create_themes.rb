class CreateThemes < ActiveRecord::Migration[6.1]
  def change
    create_table :themes do |t|
      t.string :element
      t.string :value

      t.timestamps
    end
  end
end
