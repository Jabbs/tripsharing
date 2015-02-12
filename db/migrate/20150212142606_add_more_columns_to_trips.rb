class AddMoreColumnsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :no_couples, :integer, default: 0
    add_column :trips, :no_singles, :integer, default: 0
    add_column :trips, :no_families, :integer, default: 0
    add_column :trips, :group_dynamics, :string, limit: 255
  end
end
