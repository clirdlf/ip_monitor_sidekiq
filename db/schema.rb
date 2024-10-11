# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2020_07_06_144129) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "grants", force: :cascade do |t|
    t.string "title"
    t.string "institution"
    t.string "grant_number"
    t.string "contact"
    t.string "email"
    t.date "submission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "program"
    t.integer "resources_count"
    t.string "filename"
    t.index ["filename"], name: "index_grants_on_filename", unique: true
  end

  create_table "resources", force: :cascade do |t|
    t.string "access_filename"
    t.string "access_url"
    t.string "checksum"
    t.boolean "restricted"
    t.text "restricted_comments"
    t.bigint "grant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statuses_count"
    t.index ["grant_id"], name: "index_resources_on_grant_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "response_code"
    t.string "response_message"
    t.decimal "response_time"
    t.string "status"
    t.boolean "latest"
    t.text "status_message"
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_statuses_on_resource_id"
  end

  add_foreign_key "resources", "grants"
  add_foreign_key "statuses", "resources"
end
