class AddDefaultStateToJoinRequests < ActiveRecord::Migration
  def change
    change_column :join_requests, :state, :string, default: "0"
  end
end
