class ChangeNamesInTripsGroups < ActiveRecord::Migration
  
  def up
    remove_column :trips, :age_min
    remove_column :trips, :age_max
    remove_column :trips, :group_min
    remove_column :trips, :group_max
    remove_column :trips, :seeking_count
    add_column :trips, :group_age_min, :string, default: "18"
    add_column :trips, :group_age_max, :string
    add_column :trips, :group_count, :string
    add_column :trips, :group_departing_proximity, :string
    add_column :trips, :group_relationship_status, :string
    add_column :trips, :group_drinking, :string
    add_column :trips, :group_personality, :string
    add_column :trips, :group_nationality, :string
  end
  
  def down
    add_column :trips, :group_min, :string
    add_column :trips, :group_max, :string
    add_column :trips, :age_min, :string
    add_column :trips, :age_max, :string
    add_column :trips, :seeking_count, :string
    remove_column :trips, :group_nationality
    remove_column :trips, :group_age_min
    remove_column :trips, :group_age_max
    remove_column :trips, :group_count
    remove_column :trips, :group_departing_proximity
    remove_column :trips, :group_relationship_status
    remove_column :trips, :group_drinking
    remove_column :trips, :group_personality
  end
  
end
