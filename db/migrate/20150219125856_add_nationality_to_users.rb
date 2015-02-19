class AddNationalityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nationality, :string
    add_column :users, :looking_for, :string
  end
end
