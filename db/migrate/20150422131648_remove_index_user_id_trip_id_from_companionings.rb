class RemoveIndexUserIdTripIdFromCompanionings < ActiveRecord::Migration
  def up
    remove_index :companionings, [:user_id, :trip_id]
  end
  
  def down
    add_index :companionings, [:user_id, :trip_id], unique: true
  end
end
