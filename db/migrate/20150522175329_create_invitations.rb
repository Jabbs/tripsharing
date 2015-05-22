class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :trip_id, null: false
      t.integer :user_id, null: false
      t.datetime :sent_at

      t.timestamps
    end
    add_index :invitations, :email
    add_index :invitations, :trip_id
  end
end
