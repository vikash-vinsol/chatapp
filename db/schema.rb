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

ActiveRecord::Schema.define(version: 20141008193204) do

  create_table "content_receivers", force: true do |t|
    t.integer  "receiver_id"
    t.integer  "content_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", force: true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.datetime "attachment_update_at"
    t.integer  "timer"
    t.integer  "receiver_count",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["user_id"], name: "index_contents_on_user_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name",        null: false
    t.string   "iso",         null: false
    t.string   "mobile_code", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "friend_invitations", force: true do |t|
    t.integer  "inviter_id", null: false
    t.integer  "invitee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "account_name",                               null: false
    t.string   "firstname",                                  null: false
    t.string   "lastname",                                   null: false
    t.integer  "country_id",                                 null: false
    t.string   "mobile",                                     null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "device_type"
    t.string   "device_token"
    t.string   "verification_token"
    t.boolean  "verified",                   default: false
    t.datetime "verification_token_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_name"], name: "index_users_on_account_name", unique: true, using: :btree
  add_index "users", ["country_id"], name: "index_users_on_country_id", using: :btree
  add_index "users", ["device_token"], name: "index_users_on_device_token", unique: true, using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree

end
