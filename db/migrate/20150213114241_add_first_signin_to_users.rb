class AddFirstSigninToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_to_first_trip, :boolean, default: false
  end
end
