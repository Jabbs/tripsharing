class AddIndexToNotifications < ActiveRecord::Migration
  def up
    add_index :notifications, :trigger_code
    remove_column :notifications, :email_sent_at
    remove_column :notifications, :email_sent
    remove_column :notifications, :email_viewed
    add_column :trips, :new_email_sent_at, :datetime
  end
  
  def down
    remove_index :notifications, :trigger_code
    add_column :notifications, :email_sent_at, :datetime
    add_column :notifications, :email_sent, :boolean
    add_column :notifications, :email_viewed, :boolean
    remove_column :trips, :new_email_sent_at
  end
end
