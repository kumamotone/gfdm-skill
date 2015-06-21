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

ActiveRecord::Schema.define(version: 20150621111801) do

  create_table "musics", force: true do |t|
    t.string   "name",       null: false
    t.string   "bpm"
    t.float    "d_bsc"
    t.float    "d_adv"
    t.float    "d_ext"
    t.float    "d_mas"
    t.float    "g_bsc"
    t.float    "g_adv"
    t.float    "g_ext"
    t.float    "g_mas"
    t.float    "b_bsc"
    t.float    "b_adv"
    t.float    "b_ext"
    t.float    "b_mas"
    t.boolean  "ishot",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: true do |t|
    t.integer  "music_id"
    t.integer  "user_id"
    t.integer  "kind"
    t.float    "rate"
    t.float    "sp"
    t.string   "comment"
    t.boolean  "isfc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["music_id"], name: "index_skills_on_music_id"
  add_index "skills", ["user_id", "music_id"], name: "index_skills_on_user_id_and_music_id"
  add_index "skills", ["user_id"], name: "index_skills_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
