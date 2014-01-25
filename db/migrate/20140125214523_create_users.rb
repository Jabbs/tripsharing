class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true, limit: 255
      t.string :first_name, limit: 255
      t.string :last_name, limit: 255
      t.string :password_digest, limit: 255
      t.string :auth_token, limit: 255
      t.string :password_reset_token, limit: 255
      t.datetime :password_reset_sent_at
      t.boolean :admin, default: false
      t.string :slug, limit: 255
      t.boolean :verified, default: false
      t.string :verification_token, limit: 255
      t.datetime :verification_sent_at
      t.integer :sign_in_count, default: 0
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip, limit: 255
      t.string :phone, limit: 255
      t.string :gender, limit: 255
      t.boolean :newsletter, default: false
      t.string :birth_year, limit: 255
      t.boolean :subscribed, default: true
      t.string :uid, limit: 255
      t.string :oauth_token, limit: 255
      t.datetime :oauth_expires_at
      t.string :fb_hometown, limit: 255
      t.string :fb_image, limit: 255
      t.string :fb_url, limit: 255
      t.string :fb_location, limit: 255

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :slug
  end
end
