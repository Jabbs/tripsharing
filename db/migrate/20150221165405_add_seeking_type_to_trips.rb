class AddSeekingTypeToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :seeking_type, :string
    add_column :trips, :seeking_count, :string
  end
end
