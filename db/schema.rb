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

ActiveRecord::Schema.define(version: 20151208161103) do

  create_table "customer_adresses", force: :cascade do |t|
    t.string   "rue"
    t.string   "complement"
    t.string   "code_postal"
    t.string   "ville"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
    t.string   "name"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "customer_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "civilite"
  end

  create_table "estimation_prestation_lines", force: :cascade do |t|
    t.integer  "estimation_volet_id"
    t.integer  "prestation_id"
    t.integer  "quantite"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "volet_id"
  end

  create_table "estimation_volets", force: :cascade do |t|
    t.string   "libelle"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "estimation_id"
  end

  create_table "estimations", force: :cascade do |t|
    t.string   "reference"
    t.text     "objet"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "customer_id"
    t.date     "validity_date"
    t.text     "intervention_dates"
    t.string   "libelle"
  end

  create_table "prestation_models", force: :cascade do |t|
    t.string   "libelle"
    t.string   "description"
    t.decimal  "price"
    t.string   "unite"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "prestations", force: :cascade do |t|
    t.string   "libelle"
    t.string   "description"
    t.decimal  "price"
    t.string   "unite"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "tva_id"
  end

  create_table "tvas", force: :cascade do |t|
    t.decimal  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
