class AddColumnsToTrips < ActiveRecord::Migration
  def change
    remove_column :trips, :active
    remove_column :trips, :group_size
    add_column :trips, :group_min, :integer
    add_column :trips, :group_max, :integer
    add_column :trips, :state, :string, default: "pending"
    add_column :trips, :initialized_with_signup, :boolean, default: false
    add_column :trips, :audience, :string, default: "public"
    add_column :trips, :duration_in_days, :integer
    add_column :trips, :price_dollars_low, :string
    add_column :trips, :price_dollars_high, :string
  end
end
