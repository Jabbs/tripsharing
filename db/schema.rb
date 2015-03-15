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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150315143912) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at",                null: false
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "image_attachments", force: true do |t|
    t.string   "image_attachable_type"
    t.integer  "image_attachable_id"
    t.string   "image"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "image_attachments", ["image_attachable_id"], name: "index_image_attachments_on_image_attachable_id", using: :btree
  add_index "image_attachments", ["image_attachable_type"], name: "index_image_attachments_on_image_attachable_type", using: :btree

  create_table "interests", force: true do |t|
    t.integer  "user_id"
    t.string   "identifier"
    t.boolean  "has_it",     default: false
    t.string   "category"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "interests", ["identifier"], name: "index_interests_on_identifier", using: :btree
  add_index "interests", ["user_id"], name: "index_interests_on_user_id", using: :btree

  create_table "join_requests", force: true do |t|
    t.integer  "trip_id"
    t.integer  "user_id"
    t.text     "content"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "locationable_id"
    t.string   "locationable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "unparsed"
  end

  add_index "locations", ["country"], name: "index_locations_on_country", using: :btree
  add_index "locations", ["locationable_id", "locationable_type"], name: "index_locations_on_locationable_id_and_locationable_type", using: :btree

  create_table "stops", force: true do |t|
    t.integer  "trip_id"
    t.integer  "user_id"
    t.string   "to_iata"
    t.string   "from_iata"
    t.string   "to_name",                           null: false
    t.string   "from_name"
    t.string   "transportation_type", default: "1"
    t.integer  "order",               default: 1
    t.datetime "to_date"
    t.datetime "from_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "to_name_dest"
  end

  add_index "stops", ["from_iata"], name: "index_stops_on_from_iata", using: :btree
  add_index "stops", ["to_iata"], name: "index_stops_on_to_iata", using: :btree
  add_index "stops", ["trip_id"], name: "index_stops_on_trip_id", using: :btree

  create_table "surveys", force: true do |t|
    t.string   "destination"
    t.integer  "companion_count"
    t.integer  "user_id"
    t.string   "month"
    t.string   "hometown"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "companion_type"
    t.string   "organizer_type"
  end

  add_index "surveys", ["user_id"], name: "index_surveys_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "trip_users", force: true do |t|
    t.integer  "trip_id"
    t.integer  "user_id"
    t.string   "status",       default: "pending"
    t.text     "introduction"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "trip_users", ["status"], name: "index_trip_users_on_status", using: :btree
  add_index "trip_users", ["trip_id"], name: "index_trip_users_on_trip_id", using: :btree
  add_index "trip_users", ["user_id"], name: "index_trip_users_on_user_id", using: :btree

  create_table "trips", force: true do |t|
    t.string   "name"
    t.datetime "expires_at"
    t.text     "description"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "slug"
    t.integer  "view_count",                default: 0
    t.integer  "user_id"
    t.boolean  "initialized_with_signup",   default: false
    t.string   "audience",                  default: "public"
    t.integer  "duration_in_days"
    t.string   "price_dollars_low"
    t.string   "price_dollars_high"
    t.datetime "departs_at"
    t.string   "group_dynamics"
    t.string   "state",                     default: "1"
    t.string   "currency",                  default: "USD"
    t.string   "region"
    t.boolean  "private",                   default: false
    t.string   "seeking_type"
    t.datetime "returns_at"
    t.string   "duration"
    t.string   "time_flexibility"
    t.string   "departing_category"
    t.string   "departs_from"
    t.string   "departs_to"
    t.string   "group_age_min",             default: "18"
    t.string   "group_age_max"
    t.string   "group_count"
    t.string   "group_departing_proximity"
    t.string   "group_relationship_status"
    t.string   "group_drinking"
    t.string   "group_personality"
    t.string   "group_nationality"
    t.string   "reason"
    t.string   "default_image"
  end

  add_index "trips", ["name"], name: "index_trips_on_name", using: :btree
  add_index "trips", ["region"], name: "index_trips_on_region", using: :btree
  add_index "trips", ["slug"], name: "index_trips_on_slug", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                  null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin",                  default: false
    t.string   "slug"
    t.boolean  "verified",               default: false
    t.string   "verification_token"
    t.datetime "verification_sent_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.string   "phone"
    t.string   "gender"
    t.boolean  "newsletter",             default: false
    t.string   "birth_year"
    t.boolean  "subscribed",             default: true
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "fb_hometown"
    t.string   "fb_image"
    t.string   "fb_url"
    t.string   "fb_location"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "tag_line"
    t.text     "bio"
    t.datetime "welcome_sent_at"
    t.string   "occupation"
    t.string   "fb_locale"
    t.string   "fb_timezone"
    t.string   "fb_updated_time"
    t.date     "birthday"
    t.string   "hometown"
    t.boolean  "send_to_first_trip",     default: false
    t.string   "nationality"
    t.string   "looking_for"
    t.string   "fb_occupation"
    t.string   "home_airport"
    t.string   "location"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
