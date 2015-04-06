class AddValidationsAndLimitsToTrips < ActiveRecord::Migration
  def up
    change_column :trips, :name, :string, null: false, limit: 250
    change_column :trips, :description, :text, limit: 50000
    change_column :trips, :region, :string, null: false
    add_index :trips, :state
  end
  
  def down
    change_column :trips, :name, :string
    change_column :trips, :description, :text
    change_column :trips, :region, :string
    remove_index :trips, :state
  end
end
