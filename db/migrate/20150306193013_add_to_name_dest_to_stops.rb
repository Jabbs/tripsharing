class AddToNameDestToStops < ActiveRecord::Migration
  def change
    add_column :stops, :to_name_dest, :string
  end
end
