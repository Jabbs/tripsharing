class AddIndexToNotifications < ActiveRecord::Migration
  def up
    add_index :notifications, :trigger_code
    remove_column :notifications, :email_sent
    remove_column :notifications, :email_sent_at
  end
  
  def down
    remove_index :notifications, :trigger_code
    add_column :notifications, :email_sent, :boolean, default: false
    add_column :notifications, :email_sent_at, :datetime
  end
end
