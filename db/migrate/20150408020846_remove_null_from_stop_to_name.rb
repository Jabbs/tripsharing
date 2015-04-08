class RemoveNullFromStopToName < ActiveRecord::Migration
  def change
    change_column :stops, :to_name, :string, limit: 1000
  end
end
