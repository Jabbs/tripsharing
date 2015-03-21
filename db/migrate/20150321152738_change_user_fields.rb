class ChangeUserFields < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, default: "1"
    add_column :users, :education, :string
    add_column :users, :country_blob, :text
    add_column :users, :language_blob, :text
    add_column :users, :interest_blob, :text, default: "1-0,2-0,3-0,4-0,5-0,6-0"
  end
end
