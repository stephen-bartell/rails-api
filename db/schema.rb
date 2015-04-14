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

ActiveRecord::Schema.define(version: 20150405220302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "entries", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "team_id"
    t.uuid     "player_id"
    t.date     "date"
    t.string   "category"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "team_id"
    t.string   "slack_id"
    t.string   "name"
    t.string   "real_name"
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.integer  "points",        default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "scrums", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "team_id"
    t.uuid     "player_id"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "teams", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "slack_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
