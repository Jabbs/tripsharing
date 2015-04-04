class AddWelcomeCompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_complete, :boolean, default: false
  end
end
