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

ActiveRecord::Schema[7.2].define(version: 2025_01_29_135548) do
  create_table "roles", force: :cascade do |t|
    t.string "role_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status"
    t.integer "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_signs_on_video_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "sign_id"
    t.integer "submitted_by"
    t.integer "approved_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by"], name: "index_submissions_on_approved_by"
    t.index ["sign_id"], name: "index_submissions_on_sign_id"
    t.index ["submitted_by"], name: "index_submissions_on_submitted_by"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.integer "role_id", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "video_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "signs", "videos"
  add_foreign_key "submissions", "signs"
  add_foreign_key "submissions", "users", column: "approved_by"
  add_foreign_key "submissions", "users", column: "submitted_by"
  add_foreign_key "users", "roles"
end
