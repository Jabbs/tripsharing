class AddFeaturedToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :featured, :boolean, default: false
  end
end
