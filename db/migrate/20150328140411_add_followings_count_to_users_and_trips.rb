class AddFollowingsCountToUsersAndTrips < ActiveRecord::Migration
  def change
    add_column :users, :followings_count, :integer, default: 0
    add_column :trips, :followings_count, :integer, default: 0
  end
end
