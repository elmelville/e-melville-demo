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

ActiveRecord::Schema.define(version: 20161213111541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "preference", force: :cascade do |t|
    t.string   "shop_url"
    t.string   "origin_postal_code"
    t.string   "default_weight"
    t.integer  "height"
    t.integer  "width"
    t.integer  "length"
    t.float    "surcharge_percentage"
    t.integer  "items_per_box"
    t.decimal  "default_charge"
    t.string   "shipping_methods_allowed_int"
    t.integer  "container_weight"
    t.string   "shipping_methods_allowed_dom"
    t.integer  "default_box_size"
    t.string   "shipping_methods_desc_int"
    t.string   "shipping_methods_desc_dom"
    t.float    "surcharge_amount"
    t.boolean  "hide_welcome_note"
    t.string   "carrier"
    t.boolean  "free_shipping_option"
    t.string   "free_shipping_description"
    t.boolean  "offers_flat_rate"
    t.integer  "under_weight"
    t.integer  "flat_rate"
    t.boolean  "free_shipping_by_collection"
    t.string   "shipping_methods_long_desc_int"
    t.string   "shipping_methods_long_desc_dom"
    t.string   "rate_lookup_error"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain",    null: false
    t.string   "shopify_token",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active_subscriber"
    t.datetime "signup_date"
    t.string   "charge_id"
    t.string   "status"
    t.boolean  "theme_modified"
    t.integer  "version"
    t.string   "domain"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree
  end

end
