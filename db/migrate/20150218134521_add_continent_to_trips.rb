class AddContinentToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :region, :string
    add_index :trips, :region
  end
end
