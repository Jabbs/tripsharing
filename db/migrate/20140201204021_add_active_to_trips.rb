class AddActiveToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :active, :boolean, default: false
  end
end
