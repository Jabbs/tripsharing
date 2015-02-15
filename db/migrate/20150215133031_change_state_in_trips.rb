class ChangeStateInTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :state
    add_column :trips, :state, :string, default: "1"
  end
  def down
    remove_column :trips, :state
    add_column :trips, :state, :string, default: "pending"
  end
end
