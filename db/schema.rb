# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140126075501) do

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "image_attachments", :force => true do |t|
    t.string   "image_attachable_type"
    t.integer  "image_attachable_id"
    t.string   "image"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "image_attachments", ["image_attachable_id"], :name => "index_image_attachments_on_image_attachable_id"
  add_index "image_attachments", ["image_attachable_type"], :name => "index_image_attachments_on_image_attachable_type"

  create_table "users", :force => true do |t|
    t.string   "email",                                     :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin",                  :default => false
    t.string   "slug"
    t.boolean  "verified",               :default => false
    t.string   "verification_token"
    t.datetime "verification_sent_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.string   "phone"
    t.string   "gender"
    t.boolean  "newsletter",             :default => false
    t.string   "birth_year"
    t.boolean  "subscribed",             :default => true
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "fb_hometown"
    t.string   "fb_image"
    t.string   "fb_url"
    t.string   "fb_location"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "provider"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["slug"], :name => "index_users_on_slug"

end
