class AddNumberIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_id, :string
    add_index :users, :number_id
  end
end
