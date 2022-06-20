class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string :homepage_heading_1
      t.string :footer_copyright
      t.string :logo_image_path

      t.timestamps
    end
  end
end
