class ChangeUserFields < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, default: "1"
    add_column :users, :education, :string
    add_column :users, :country_blob, :text, default: ""
    add_column :users, :language_blob, :text, default: ""
    add_column :users, :interest_blob, :text, default: ""
  end
end
