class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.integer :user_id, null: false
      t.integer :activity_id, null: false

      t.timestamps
    end
    add_index :feed_items, :user_id
    add_index :feed_items, :activity_id
    add_index :feed_items, [:user_id, :activity_id], unique: true
  end
end
