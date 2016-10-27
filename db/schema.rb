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

ActiveRecord::Schema.define(version: 20161027175100) do

  create_table "actionmodules", force: :cascade do |t|
    t.integer  "countertype"
    t.integer  "countertime"
    t.string   "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "action_id"
  end

  add_index "actionmodules", ["action_id"], name: "index_actionmodules_on_action_id"

  create_table "actions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "task_id"
  end

  add_index "actions", ["task_id"], name: "index_actions_on_task_id"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "activity_type"
    t.integer  "activity_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "feed_type",     default: 0
    t.integer  "status",        default: 0
  end

  create_table "activities_users", id: false, force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "activities_users", ["activity_id"], name: "index_activities_users_on_activity_id"
  add_index "activities_users", ["user_id"], name: "index_activities_users_on_user_id"

  create_table "challenges", force: :cascade do |t|
    t.string   "title"
    t.string   "prize"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  add_index "challenges", ["user_id"], name: "index_challenges_on_user_id"

  create_table "completes", force: :cascade do |t|
    t.string   "video"
    t.string   "image"
    t.integer  "invite_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "task_date_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description",        limit: 2200
  end

  add_index "completes", ["task_date_id"], name: "index_completes_on_task_date_id"

  create_table "followers", force: :cascade do |t|
    t.integer  "follower_one_id"
    t.integer  "follower_two_id"
    t.integer  "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "followers", ["follower_one_id"], name: "index_followers_on_follower_one_id"
  add_index "followers", ["follower_two_id"], name: "index_followers_on_follower_two_id"

  create_table "friends", force: :cascade do |t|
    t.integer  "friend_one_id"
    t.integer  "friend_two_id"
    t.integer  "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "friends", ["friend_one_id"], name: "index_friends_on_friend_one_id"
  add_index "friends", ["friend_two_id"], name: "index_friends_on_friend_two_id"

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "accepted"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "presignups", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_dates", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "task_id"
  end

  add_index "task_dates", ["task_id"], name: "index_task_dates_on_task_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.integer  "challenge_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "tasks", ["challenge_id"], name: "index_tasks_on_challenge_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "birthday"
    t.string   "username"
    t.string   "phone"
    t.string   "email"
    t.string   "password"
    t.string   "gender"
    t.boolean  "active"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "auth_token"
    t.string   "cleartext_password"
    t.boolean  "is_super_admin",            default: false
    t.boolean  "is_admin",                  default: false
    t.string   "encrypted_password",        default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "profileimage"
    t.string   "coverimage"
    t.string   "profileimage_file_name"
    t.string   "profileimage_content_type"
    t.integer  "profileimage_file_size"
    t.datetime "profileimage_updated_at"
    t.string   "coverimage_file_name"
    t.string   "coverimage_content_type"
    t.integer  "coverimage_file_size"
    t.datetime "coverimage_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
