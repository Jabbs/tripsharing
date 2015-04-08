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

ActiveRecord::Schema.define(version: 20150408020846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "user_id",                            null: false
    t.string   "action",                             null: false
    t.integer  "trackable_id",                       null: false
    t.string   "trackable_type",                     null: false
    t.boolean  "notifications_sent", default: false
    t.boolean  "created_feed_items", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["trackable_id"], name: "index_activities_on_trackable_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "companionings", force: true do |t|
    t.integer  "trip_id",                  null: false
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "role",       default: "0", null: false
  end

  add_index "companionings", ["trip_id"], name: "index_companionings_on_trip_id", using: :btree
  add_index "companionings", ["user_id", "trip_id"], name: "index_companionings_on_user_id_and_trip_id", unique: true, using: :btree
  add_index "companionings", ["user_id"], name: "index_companionings_on_user_id", using: :btree

  create_table "feed_items", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "activity_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["activity_id"], name: "index_feed_items_on_activity_id", using: :btree
  add_index "feed_items", ["user_id", "activity_id"], name: "index_feed_items_on_user_id_and_activity_id", unique: true, using: :btree
  add_index "feed_items", ["user_id"], name: "index_feed_items_on_user_id", using: :btree

  create_table "followings", force: true do |t|
    t.string   "followable_type", null: false
    t.integer  "followable_id",   null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followable_id"], name: "index_followings_on_followable_id", using: :btree
  add_index "followings", ["user_id"], name: "index_followings_on_user_id", using: :btree

  create_table "friendings", force: true do |t|
    t.integer  "friend_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendings", ["friend_id", "user_id"], name: "index_friendings_on_friend_id_and_user_id", unique: true, using: :btree

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
    t.string   "image_attachable_type", null: false
    t.integer  "image_attachable_id",   null: false
    t.string   "image",                 null: false
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
    t.integer  "trip_id",                              null: false
    t.integer  "user_id",                              null: false
    t.text     "content",                              null: false
    t.string   "state",                  default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "new_email_sent_at"
    t.datetime "accepted_email_sent_at"
  end

  add_index "join_requests", ["trip_id"], name: "index_join_requests_on_trip_id", using: :btree
  add_index "join_requests", ["user_id", "trip_id"], name: "index_join_requests_on_user_id_and_trip_id", unique: true, using: :btree
  add_index "join_requests", ["user_id"], name: "index_join_requests_on_user_id", using: :btree

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

  create_table "messages", force: true do |t|
    t.integer  "sender_id",                                  null: false
    t.integer  "receiver_id",                                null: false
    t.text     "content",                                    null: false
    t.string   "subject",       limit: 1000
    t.boolean  "viewed",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "email_sent_at"
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id",                           null: false
    t.boolean  "badge_icon_viewed", default: false
    t.string   "trigger_code",                      null: false
    t.string   "action_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["trigger_code"], name: "index_notifications_on_trigger_code", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "stops", force: true do |t|
    t.integer  "trip_id"
    t.integer  "user_id"
    t.string   "to_iata",             limit: 1000
    t.string   "from_iata",           limit: 1000
    t.string   "to_name",             limit: 1000,               null: false
    t.string   "from_name",           limit: 1000
    t.string   "transportation_type",              default: "1"
    t.integer  "order",                            default: 1
    t.datetime "to_date"
    t.datetime "from_date"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
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
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",       limit: 250, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "trips", force: true do |t|
    t.string   "name",               limit: 250,                 null: false
    t.datetime "expires_at"
    t.text     "description"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "slug"
    t.integer  "view_count",                     default: 0
    t.integer  "user_id"
    t.integer  "duration_in_days"
    t.datetime "departs_at"
    t.string   "group_dynamics"
    t.string   "state",                          default: "1"
    t.string   "region",                                         null: false
    t.boolean  "private",                        default: false
    t.string   "seeking_type"
    t.datetime "returns_at"
    t.string   "duration"
    t.string   "time_flexibility"
    t.string   "departing_category"
    t.string   "group_count"
    t.string   "group_nationality",              default: "0"
    t.string   "default_image"
    t.text     "reason"
    t.integer  "group_age_min",                  default: 0
    t.integer  "group_age_max",                  default: 0
    t.integer  "followings_count",               default: 0
    t.string   "stop_location"
    t.string   "user_occupation"
    t.string   "user_nationality"
    t.text     "user_interest_blob"
    t.datetime "new_email_sent_at"
  end

  add_index "trips", ["name"], name: "index_trips_on_name", using: :btree
  add_index "trips", ["region"], name: "index_trips_on_region", using: :btree
  add_index "trips", ["slug"], name: "index_trips_on_slug", using: :btree
  add_index "trips", ["state"], name: "index_trips_on_state", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  limit: 300,                  null: false
    t.string   "first_name",             limit: 200,                  null: false
    t.string   "last_name",              limit: 200,                  null: false
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin",                               default: false
    t.string   "slug"
    t.boolean  "verified",                            default: false
    t.string   "verification_token"
    t.datetime "verification_sent_at"
    t.integer  "sign_in_count",                       default: 0
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.string   "phone"
    t.string   "gender",                                              null: false
    t.boolean  "newsletter",                          default: false
    t.boolean  "subscribed",                          default: true
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "fb_hometown"
    t.string   "fb_image"
    t.string   "fb_url"
    t.string   "fb_location"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "provider"
    t.string   "tag_line",               limit: 1000
    t.text     "bio"
    t.datetime "welcome_sent_at"
    t.string   "occupation",             limit: 300
    t.string   "fb_locale"
    t.string   "fb_timezone"
    t.string   "fb_updated_time"
    t.date     "birthday",                                            null: false
    t.string   "hometown",               limit: 300
    t.boolean  "send_to_first_trip",                  default: false
    t.string   "nationality"
    t.string   "fb_occupation"
    t.string   "home_airport",           limit: 1000
    t.string   "location",               limit: 1000
    t.string   "number_id"
    t.text     "activity_trail",                      default: "1"
    t.string   "status",                              default: "1"
    t.string   "education",              limit: 3000
    t.text     "country_blob",                        default: ""
    t.text     "language_blob",                       default: ""
    t.text     "interest_blob",                       default: ""
    t.text     "email_blob",                          default: ""
    t.integer  "followings_count",                    default: 0
    t.string   "region_blob",                         default: ""
    t.boolean  "welcome_complete",                    default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["number_id"], name: "index_users_on_number_id", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
