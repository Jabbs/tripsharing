class CreateTripApplications < ActiveRecord::Migration
  def change
    create_table :trip_applications do |t|
      t.integer :trip_id
      t.integer :user_id
      t.string :status, default: "pending"
      t.text :introduction

      t.timestamps, :null => false
    end
    add_index :trip_applications, :trip_id
    add_index :trip_applications, :user_id
    add_index :trip_applications, :status
  end
end
