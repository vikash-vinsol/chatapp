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

ActiveRecord::Schema.define(version: 20140909171212) do

  create_table "countries", force: true do |t|
    t.string   "name",       null: false
    t.string   "iso",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "account_name",         null: false
    t.string   "firstname",            null: false
    t.string   "lastname",             null: false
    t.integer  "country_id",           null: false
    t.string   "mobile",               null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "device_type"
    t.string   "device_token"
    t.string   "verification_token"
    t.boolean  "verified"
    t.boolean  "verification_expired"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
