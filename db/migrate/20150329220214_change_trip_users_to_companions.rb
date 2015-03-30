class ChangeTripUsersToCompanions < ActiveRecord::Migration
  def up
    rename_table :trip_users, :companionings
    remove_column :companionings, :status
    remove_column :companionings, :introduction
    add_column :companionings, :role, :string, default: "0", null: false
    change_column :companionings, :user_id, :integer, null: false
    change_column :companionings, :trip_id, :integer, null: false
    add_index :companionings, [:user_id, :trip_id], unique: true
  end
  
  def down
    rename_table :companionings, :trip_users
    add_column :trip_users, :status, :string, default: "pending"
    add_column :trip_users, :introduction, :text
    remove_column :trip_users, :role
    change_column :trip_users, :user_id, :integer
    change_column :trip_users, :trip_id, :integer
  end
end
