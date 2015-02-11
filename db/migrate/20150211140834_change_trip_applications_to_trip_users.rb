class ChangeTripApplicationsToTripUsers < ActiveRecord::Migration
  def change
    rename_table :trip_applications, :trip_users
  end
end
