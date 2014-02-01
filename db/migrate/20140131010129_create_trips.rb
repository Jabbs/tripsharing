class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.datetime :expires_at
      t.string :age_min
      t.string :age_max
      t.string :group_size
      t.text :description

      t.timestamps
    end
    add_index :trips, :name
  end
end
