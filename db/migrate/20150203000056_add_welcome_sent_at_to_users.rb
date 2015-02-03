class AddWelcomeSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_sent_at, :datetime
    add_column :users, :occupation, :string
    add_column :users, :fb_locale, :string
    add_column :users, :fb_timezone, :string
    add_column :users, :fb_updated_time, :string
  end
end
