class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :trip_id
      t.integer :user_id
      t.string :to_iata
      t.string :from_iata
      t.string :to_name, null: false
      t.string :from_name
      t.string :transportation_type, default: "1"
      t.integer :order, default: 1

      t.timestamps null: false
    end
    add_index :stops, :to_iata
    add_index :stops, :from_iata
    add_index :stops, :trip_id
  end
end
