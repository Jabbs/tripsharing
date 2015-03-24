class ChangeReasonInTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :reason
    add_column :trips, :reason, :text
    change_column :trips, :group_nationality, :string, default: "0"
  end
 
  def down
    remove_column :trips, :reason
    add_column :trips, :reason, :string
    change_column :trips, :group_nationality, :string
  end
end
