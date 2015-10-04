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

ActiveRecord::Schema.define(version: 20151004015553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "entries", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "player_id"
    t.uuid     "scrum_id"
    t.string   "category"
    t.text     "body"
    t.integer  "points",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "jid"
    t.string   "method_string",                    null: false
    t.string   "reoccurrence_crontab"
    t.datetime "run_at"
    t.integer  "run_count",            default: 1
    t.string   "status"
    t.uuid     "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "jobs", ["jid"], name: "index_jobs_on_jid", using: :btree

  create_table "players", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "team_id"
    t.string   "slack_id"
    t.string   "name"
    t.string   "real_name"
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.integer  "points",        default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "notifications", default: true
  end

  create_table "players_scrums", force: :cascade do |t|
    t.uuid     "player_id"
    t.uuid     "scrum_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrums", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "team_id"
    t.date     "date"
    t.integer  "points",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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
    t.string   "auth_token"
    t.integer  "points",              default: 0
    t.string   "slack_id"
    t.string   "bot_url"
    t.string   "prompt_at"
    t.string   "prompt_jid"
    t.string   "remind_at"
    t.string   "remind_jid"
    t.string   "summary_at"
    t.string   "summary_jid"
    t.string   "timezone"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "do_not_disturb_days", default: ["6", "7"],              array: true
  end

end
