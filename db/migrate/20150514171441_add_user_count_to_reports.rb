class AddUserCountToReports < ActiveRecord::Migration
  def change
    add_column :reports, :user_count, :string, default: ""
    add_column :reports, :monthly_active_user_count, :string, default: ""
  end
end
