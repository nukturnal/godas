class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.references :district, foreign_key: true
      t.string :code
      t.string :district_code
      t.string :city_code
      t.string :region_code
      t.string :address
      t.float :longitude, precision: 10, scale: 8
      t.float :latitude, precision: 10, scale: 8

      t.timestamps
    end
  end
end
