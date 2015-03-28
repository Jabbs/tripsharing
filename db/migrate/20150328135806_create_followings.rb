class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.string :followable_type
      t.integer :followable_id
      t.integer :user_id

      t.timestamps
    end
    add_index :followings, :user_id
    add_index :followings, :followable_id
  end
end
