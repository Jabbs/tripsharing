class ChangeReasonInTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :reason
    remove_column :trips, :group_age_min
    remove_column :trips, :group_age_max
    add_column :trips, :reason, :text
    add_column :trips, :group_age_min, :integer, default: 0
    add_column :trips, :group_age_max, :integer, default: 0
    change_column :trips, :group_nationality, :string, default: "0"
  end
 
  def down
    remove_column :trips, :reason
    remove_column :trips, :group_age_min
    remove_column :trips, :group_age_max
    add_column :trips, :reason, :string
    add_column :trips, :group_age_min, :string, default: "18"
    add_column :trips, :group_age_max, :string
    change_column :trips, :group_nationality, :string
  end
end
