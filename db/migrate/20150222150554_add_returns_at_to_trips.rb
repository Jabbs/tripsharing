class AddReturnsAtToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :returns_at, :datetime
  end
end
