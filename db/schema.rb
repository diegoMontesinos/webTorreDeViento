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

ActiveRecord::Schema.define(version: 20140518174201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carousel_elements", force: true do |t|
    t.integer  "photo"
    t.integer  "home_carousel_id"
    t.decimal  "x"
    t.decimal  "y"
    t.decimal  "w"
    t.decimal  "h"
    t.integer  "previous"
    t.integer  "next"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carousel_elements", ["home_carousel_id"], name: "index_carousel_elements_on_home_carousel_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "colaborator_grid_elements", force: true do |t|
    t.integer  "colaborator_id"
    t.string   "box"
    t.string   "sprocket"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accessFrequent"
    t.string   "sprocket2"
  end

  add_index "colaborator_grid_elements", ["colaborator_id"], name: "index_colaborator_grid_elements_on_colaborator_id", using: :btree

  create_table "colaborator_translations", force: true do |t|
    t.integer  "colaborator_id"
    t.string   "language_code"
    t.text     "semblance_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colaborator_translations", ["colaborator_id", "language_code"], name: "colaborator_trans_index", unique: true, using: :btree

  create_table "colaborators", force: true do |t|
    t.string   "name"
    t.text     "title"
    t.text     "semblance_text"
    t.string   "cv"
    t.string   "semblance"
    t.boolean  "frequent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cv_en"
    t.string   "semblance_en"
    t.string   "sproket_1"
    t.string   "sproket_2"
    t.string   "portrait"
  end

  create_table "downloads", force: true do |t|
    t.string   "title"
    t.string   "attachment"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_folder_translations", force: true do |t|
    t.integer  "file_folder_id"
    t.string   "language_code"
    t.string   "name_folder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "file_folder_translations", ["file_folder_id", "language_code"], name: "file_folder_translations_index", unique: true, using: :btree

  create_table "file_folders", force: true do |t|
    t.string   "name_folder"
    t.integer  "holdable_id"
    t.string   "holdable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display"
  end

  create_table "grid_elements", force: true do |t|
    t.integer  "work_grid_id"
    t.string   "box"
    t.decimal  "x"
    t.decimal  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_id"
    t.integer  "display"
    t.decimal  "h"
    t.decimal  "w"
  end

  add_index "grid_elements", ["work_grid_id"], name: "index_grid_elements_on_work_grid_id", using: :btree
  add_index "grid_elements", ["work_id"], name: "index_grid_elements_on_work_id", using: :btree

  create_table "home_carousels", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "head"
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.string   "image_new"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home"
    t.text     "link"
  end

  create_table "photos", force: true do |t|
    t.integer  "file_folder_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["file_folder_id"], name: "index_photos_on_file_folder_id", using: :btree

  create_table "press_elements", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "press_note_id"
  end

  add_index "press_elements", ["press_note_id"], name: "index_press_elements_on_press_note_id", using: :btree

  create_table "press_notes", force: true do |t|
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "web_info_translations", force: true do |t|
    t.integer  "web_info_id"
    t.string   "language_code"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "web_info_translations", ["web_info_id", "language_code"], name: "web_info_translations_index", unique: true, using: :btree

  create_table "web_infos", force: true do |t|
    t.string   "type_info"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_grids", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_translations", force: true do |t|
    t.integer  "work_id"
    t.string   "language_code"
    t.text     "titles_text"
    t.text     "credits"
    t.text     "synopsis"
    t.text     "program"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "titles_grid"
  end

  add_index "work_translations", ["work_id", "language_code"], name: "index_work_translations_on_work_id_and_language_code", unique: true, using: :btree

  create_table "works", force: true do |t|
    t.string   "type_work"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "titles_text"
    t.text     "credits"
    t.text     "synopsis"
    t.text     "program"
    t.text     "notes"
    t.integer  "display"
    t.string   "video"
    t.string   "videothumb"
    t.integer  "next"
    t.integer  "previous"
    t.text     "titles_grid"
  end

end
