class AddCurrencyToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :currency, :string, default: "USD"
  end
end
