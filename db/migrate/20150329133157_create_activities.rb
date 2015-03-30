class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id, null: false
      t.string :action, null: false
      t.integer :trackable_id, null: false
      t.string :trackable_type, null: false
      t.boolean :notifications_sent, default: false
      t.boolean :created_feed_items, default: false

      t.timestamps
    end
    add_index :activities, :user_id
    add_index :activities, :trackable_id
  end
end
