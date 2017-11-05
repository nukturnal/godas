class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.references :district, foreign_key: true
      t.string :code
      t.string :toplevel_code
      t.string :address
      t.float :longitude, precision: 10, scale: 8
      t.float :latitude, precision: 10, scale: 8

      t.timestamps
    end
  end
end
