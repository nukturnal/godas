class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :code
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
