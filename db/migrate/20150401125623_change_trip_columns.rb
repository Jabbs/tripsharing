class ChangeTripColumns < ActiveRecord::Migration
  
  def up
    remove_column :trips, :initialized_with_signup
    remove_column :trips, :audience
    remove_column :trips, :price_dollars_low
    remove_column :trips, :price_dollars_high
    remove_column :trips, :currency
    remove_column :trips, :departs_from
    remove_column :trips, :departs_to
    remove_column :trips, :group_departing_proximity
    remove_column :trips, :group_relationship_status
    remove_column :trips, :group_drinking
    remove_column :trips, :group_personality
    add_column :trips, :stop_location, :string
    add_column :trips, :user_occupation, :string
    add_column :trips, :user_nationality, :string
    add_column :trips, :user_interest_blob, :text
  end
  
  def down
    add_column :trips, :initialized_with_signup, :boolean
    add_column :trips, :audience, :string
    add_column :trips, :price_dollars_low, :string
    add_column :trips, :price_dollars_high, :string
    add_column :trips, :currency, :string
    add_column :trips, :departs_from, :string
    add_column :trips, :departs_to, :string
    add_column :trips, :group_departing_proximity, :string
    add_column :trips, :group_relationship_status, :string
    add_column :trips, :group_drinking, :string
    add_column :trips, :group_personality, :string
    remove_column :trips, :stop_location
    remove_column :trips, :user_occupation
    remove_column :trips, :user_nationality
    remove_column :trips, :user_interest_blob
  end
  
end
