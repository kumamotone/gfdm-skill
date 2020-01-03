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

ActiveRecord::Schema.define(version: 20160815101048) do

  create_table "musics", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "bpm",        limit: 255
    t.float    "d_bsc",      limit: 24
    t.float    "d_adv",      limit: 24
    t.float    "d_ext",      limit: 24
    t.float    "d_mas",      limit: 24
    t.float    "g_bsc",      limit: 24
    t.float    "g_adv",      limit: 24
    t.float    "g_ext",      limit: 24
    t.float    "g_mas",      limit: 24
    t.float    "b_bsc",      limit: 24
    t.float    "b_adv",      limit: 24
    t.float    "b_ext",      limit: 24
    t.float    "b_mas",      limit: 24
    t.boolean  "ishot",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: :cascade do |t|
    t.integer  "music_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "kind",       limit: 4
    t.float    "rate",       limit: 24
    t.float    "sp",         limit: 24
    t.string   "comment",    limit: 255
    t.boolean  "isfc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["music_id"], name: "index_skills_on_music_id", using: :btree
  add_index "skills", ["user_id", "music_id", "kind"], name: "index_skills_on_user_id_and_music_id_and_kind", unique: true, using: :btree
  add_index "skills", ["user_id"], name: "index_skills_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.boolean  "admin",                                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",        limit: 255
    t.string   "remember_token",         limit: 255
    t.string   "profile",                limit: 255
    t.text     "d_comment",              limit: 65535
    t.text     "g_comment",              limit: 65535
    t.string   "place",                  limit: 255
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.float    "d",                      limit: 24,    default: 0.0
    t.float    "dhot",                   limit: 24,    default: 0.0
    t.float    "dother",                 limit: 24,    default: 0.0
    t.float    "dall",                   limit: 24,    default: 0.0
    t.float    "g",                      limit: 24,    default: 0.0
    t.float    "ghot",                   limit: 24,    default: 0.0
    t.float    "gother",                 limit: 24,    default: 0.0
    t.float    "gall",                   limit: 24,    default: 0.0
    t.datetime "skill_updated_at_d"
    t.datetime "skill_updated_at_g"
    t.boolean  "subadmin",                             default: false, null: false
    t.string   "twitterid",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
