class AddDepartsAtToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :departs_at, :datetime
  end
end
