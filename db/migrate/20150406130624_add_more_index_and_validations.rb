class AddMoreIndexAndValidations < ActiveRecord::Migration
  def up
    change_column :tags, :name, :string, null: false, limit: 250
    remove_index :tags, :name
    add_index :tags, :name, unique: true
    change_column :taggings, :tag_id, :integer, null: false
    change_column :taggings, :taggable_id, :integer, null: false
    change_column :taggings, :taggable_type, :string, null: false
    change_column :stops, :to_name, :string, null: false, limit: 1000
    change_column :stops, :from_name, :string, limit: 1000
    change_column :stops, :to_iata, :string, limit: 1000
    change_column :stops, :from_iata, :string, limit: 1000
    change_column :messages, :content, :text, limit: 30000, null: false
    change_column :messages, :subject, :string, limit: 1000
    change_column :join_requests, :user_id, :integer, null: false
    change_column :join_requests, :trip_id, :integer, null: false
    change_column :join_requests, :content, :text, limit: 30000, null: false
    add_index :join_requests, :user_id
    add_index :join_requests, :trip_id
    add_index :join_requests, [:user_id, :trip_id], unique: true
    change_column :image_attachments, :image, :string, null: false
    change_column :image_attachments, :image_attachable_id, :integer, null: false
    change_column :image_attachments, :image_attachable_type, :string, null: false
    change_column :followings, :followable_type, :string, null: false
    change_column :followings, :followable_id, :integer, null: false
    change_column :followings, :user_id, :integer, null: false
  end
  
  def down
    change_column :tags, :name, :string
    remove_index :tags, :name
    add_index :tags, :name
    change_column :taggings, :tag_id, :integer
    change_column :taggings, :taggable_id, :integer
    change_column :taggings, :taggable_type, :string
    change_column :stops, :to_name, :string, null: false
    change_column :stops, :from_name, :string
    change_column :stops, :to_iata, :string
    change_column :stops, :from_iata, :string
    change_column :messages, :content, :text, null: false
    change_column :messages, :subject, :string
    change_column :join_requests, :user_id, :integer
    change_column :join_requests, :trip_id, :integer
    change_column :join_requests, :content, :text
    remove_index :join_requests, :user_id
    remove_index :join_requests, :trip_id
    remove_index :join_requests, [:user_id, :trip_id]
    change_column :image_attachments, :image, :string
    change_column :image_attachments, :image_attachable_id, :integer
    change_column :image_attachments, :image_attachable_type, :string
    change_column :followings, :followable_type, :string
    change_column :followings, :followable_id, :integer
    change_column :followings, :user_id, :integer
  end
end
