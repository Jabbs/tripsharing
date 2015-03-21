class RemoveUserColumns < ActiveRecord::Migration
  def up
    remove_column :users, :looking_for
    remove_column :users, :birth_year
  end
  def down
    add_column :users, :looking_for, :string
    add_column :users, :birth_year, :string
  end
end
