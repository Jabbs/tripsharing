class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :country
      t.string :state
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.integer :locationable_id
      t.string :locationable_type

      t.timestamps
    end
    add_index :locations, [:locationable_id, :locationable_type]
    add_index :locations, :country
  end
end
