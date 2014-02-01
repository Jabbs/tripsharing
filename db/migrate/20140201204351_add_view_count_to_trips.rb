class AddViewCountToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :view_count, :integer, default: 0
  end
end
