class AddEmailBlobToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_blob, :text, default: ""
  end
end
