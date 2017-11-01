class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :region
      t.string :city
      t.string :district
      t.string :locality
      t.string :address
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :latitude, precision: 10, scale: 6
      t.string :level_1_code
      t.string :level_2_code
      t.string :level_3_code
      t.string :digital_address
      t.string :location_code
      t.string :nickname

      t.timestamps
    end
  end
end
