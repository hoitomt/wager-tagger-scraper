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

ActiveRecord::Schema.define(version: 20161231172836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash", force: :cascade do |t|
    t.integer "tag_id"
    t.float   "amount"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name",   limit: 50
    t.float  "amount"
  end

  create_table "ticket_line_items", force: :cascade do |t|
    t.integer  "ticket_id"
    t.string   "away_team",        limit: 50
    t.integer  "away_score"
    t.string   "home_team",        limit: 50
    t.integer  "home_score"
    t.datetime "line_item_date"
    t.string   "line_item_spread", limit: 50
    t.string   "description"
  end

  create_table "ticket_tags", force: :cascade do |t|
    t.integer "ticket_id"
    t.integer "tag_id"
    t.float   "amount"
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "sb_bet_id"
    t.datetime "wager_date"
    t.string   "wager_type",     limit: 50
    t.float    "amount_wagered"
    t.float    "amount_to_win"
    t.string   "outcome",        limit: 50
    t.float    "amount_paid"
  end

end
