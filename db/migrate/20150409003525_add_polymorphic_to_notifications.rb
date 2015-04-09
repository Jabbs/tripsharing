class AddPolymorphicToNotifications < ActiveRecord::Migration
  def up
    add_column :notifications, :notificationable_type, :string, null: false
    add_column :notifications, :notificationable_id, :integer, null: false
    add_index :notifications, [:notificationable_type, :notificationable_id], name: 'index_notifications_polymorphic'
    add_index :notifications, [:user_id, :notificationable_type, :notificationable_id, :trigger_code], unique: true, name: 'index_notifications_four_way_unique'
    remove_column :notifications, :badge_icon_viewed
    add_column :notifications, :viewed, :boolean, default: false
  end
  def down
    remove_column :notifications, :notificationable_type
    remove_column :notifications, :notificationable_id
    remove_column :notifications, :viewed
    add_column :notifications, :badge_icon_viewed, :boolean, default: false
  end
end
