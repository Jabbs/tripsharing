class AddPrivateToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :private, :boolean, default: false
    remove_column :trips, :no_couples
    remove_column :trips, :no_singles
    remove_column :trips, :no_families
  end
end
