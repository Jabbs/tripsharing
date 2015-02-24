class AddFbOccupationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_occupation, :string
    add_column :users, :home_airport, :string
  end
end
