class CreateJoinRequests < ActiveRecord::Migration
  def change
    create_table :join_requests do |t|
      t.integer :trip_id
      t.integer :user_id
      t.text :content
      t.string :state

      t.timestamps
    end
  end
end
