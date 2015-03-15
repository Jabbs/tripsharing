class AddDefaultImageToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :default_image, :string
  end
end
