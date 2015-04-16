class ChangeUserInterestBlobInTrips < ActiveRecord::Migration
  def change
    change_column :trips, :user_interest_blob, :text, default: ""
  end
end
