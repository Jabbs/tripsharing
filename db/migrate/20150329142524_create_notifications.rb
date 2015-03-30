class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.boolean :email_sent, default: false
      t.datetime :email_sent_at
      t.boolean :badge_icon_viewed, default: false
      t.boolean :email_viewed, default: false
      t.string :trigger_code, null: false
      t.string :action_code

      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
