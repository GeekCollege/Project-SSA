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

ActiveRecord::Schema.define(version: 20130921093541) do

  create_table "user_assets", force: true do |t|
    t.integer  "user_base_id",              null: false
    t.integer  "experience",   default: 10, null: false
    t.integer  "learned",      default: 0
    t.integer  "teached",      default: 0
    t.integer  "topics",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_bases", force: true do |t|
    t.string   "username",                null: false
    t.string   "password",                null: false
    t.string   "seed",                    null: false
    t.string   "email",                   null: false
    t.integer  "accesslevel", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_bases", ["email"], name: "index_user_bases_on_email", unique: true
  add_index "user_bases", ["username"], name: "index_user_bases_on_username", unique: true

  create_table "user_binds", force: true do |t|
    t.integer  "user_base_id", null: false
    t.string   "target"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
  end

  create_table "user_infos", force: true do |t|
    t.integer  "user_base_id",                                 null: false
    t.string   "realname",     default: "我最强"
    t.datetime "birthday",     default: '1991-01-01 01:01:01'
    t.string   "country",      default: "中国"
    t.string   "city",         default: "北京"
    t.text     "address",      default: "不告诉你"
    t.text     "school",       default: "某个学校"
    t.string   "qq",           default: "10000"
    t.string   "phone",        default: "88888888"
    t.string   "mobile",       default: "18966666666"
    t.text     "interest",     default: "不多说"
    t.string   "gender",       default: "男"
    t.text     "signature",    default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_messages", force: true do |t|
    t.integer  "user_base_sender_id",                 null: false
    t.integer  "user_asset_id",                       null: false
    t.string   "title"
    t.text     "message"
    t.boolean  "read",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_pass_resets", force: true do |t|
    t.integer  "user_base_id", null: false
    t.string   "token",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_registration_verifications", force: true do |t|
    t.integer  "user_base_id", null: false
    t.string   "token",        null: false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sended"
  end

  create_table "user_securities", force: true do |t|
    t.integer  "user_base_id"
    t.datetime "lastlogin"
    t.datetime "lastvisit_time"
    t.string   "lastvisit_place",  default: ""
    t.string   "lastvisit_ip"
    t.datetime "release"
    t.text     "reason"
    t.string   "reset_pass_token"
    t.string   "security_quiz",                 null: false
    t.string   "security_ans",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
