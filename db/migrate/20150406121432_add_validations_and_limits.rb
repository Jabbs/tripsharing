class AddValidationsAndLimits < ActiveRecord::Migration
  
  def up
    change_column :users, :email, :string, null: false, limit: 300
    change_column :users, :first_name, :string, null: false, limit: 200
    change_column :users, :last_name, :string, null: false, limit: 200
    change_column :users, :gender, :string, null: false
    change_column :users, :birthday, :date, null: false
    remove_index :users, :email
    add_index :users, :email, unique: true
    remove_index :users, :number_id
    add_index :users, :number_id, unique: true
    change_column :users, :tag_line, :string, limit: 1000
    change_column :users, :bio, :text, limit: 50000
    change_column :users, :occupation, :string, limit: 300
    change_column :users, :hometown, :string, limit: 300
    change_column :users, :home_airport, :string, limit: 1000
    change_column :users, :location, :string, limit: 1000
    change_column :users, :education, :string, limit: 3000
  end
  
  def down
    change_column :users, :email, :string, null: false
    change_column :users, :first_name, :string
    change_column :users, :last_name, :string
    change_column :users, :gender, :string
    change_column :users, :birthday, :date
    remove_index :users, :email
    add_index :users, :email
    remove_index :users, :number_id
    add_index :users, :number_id
    change_column :users, :tag_line, :string
    change_column :users, :bio, :text
    change_column :users, :occupation, :string
    change_column :users, :hometown, :string
    change_column :users, :home_airport, :string
    change_column :users, :location, :string
    change_column :users, :education, :string
  end
end
