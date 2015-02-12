class AddUnparsedToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :unparsed, :string, limit: 255
  end
end
