class AddBadgeViewedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :badge_viewed, :boolean, default: false
    add_column :notifications, :badge_viewed, :boolean, default: false
    add_column :join_requests, :badge_viewed, :boolean, default: false
    add_column :join_requests, :viewed, :boolean, default: false
  end
end
