class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.references :district, foreign_key: true
      t.string :code
      t.string :address
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :latitude, precision: 10, scale: 6

      t.timestamps
    end
  end
end
