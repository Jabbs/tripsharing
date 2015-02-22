class AddDurationToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :duration, :string
    add_column :trips, :time_flexibility, :string
    add_column :trips, :departing_category, :string
    add_column :trips, :departs_from, :string
    add_column :trips, :departs_to, :string
  end
end
