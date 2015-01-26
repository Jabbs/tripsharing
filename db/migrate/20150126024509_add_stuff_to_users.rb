class AddStuffToUsers < ActiveRecord::Migration
  def up
    add_column :users, :tag_line, :string, limit: 255
    add_column :users, :bio, :text
  end
  
  def down
    remove_column :users, :tag_line
    remove_column :users, :bio
  end
end
