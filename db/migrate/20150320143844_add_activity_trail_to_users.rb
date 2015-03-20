class AddActivityTrailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activity_trail, :text, default: "1"
  end
end
