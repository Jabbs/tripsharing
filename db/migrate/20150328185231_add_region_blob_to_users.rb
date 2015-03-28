class AddRegionBlobToUsers < ActiveRecord::Migration
  def change
    add_column :users, :region_blob, :string, default: ""
  end
end
