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

ActiveRecord::Schema[7.1].define(version: 2025_02_11_035022) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", null: false
    t.string "name_id", null: false
    t.string "icon_original_key", default: "", null: false
    t.text "icon_variants", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.string "name", null: false
    t.text "description", default: "", null: false
    t.boolean "public", default: false, null: false
    t.bigint "likes_count", default: 0, null: false
    t.bigint "views_count", default: 0, null: false
    t.integer "posts_count", default: 0, null: false
    t.text "settings", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "metadata", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "roles", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.string "password_digest", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid", "name_id"], name: "index_accounts_on_aid_and_name_id", unique: true
    t.check_constraint "json_valid(`icon_variants`)", name: "icon_variants"
    t.check_constraint "json_valid(`metadata`)", name: "metadata"
    t.check_constraint "json_valid(`roles`)", name: "roles"
    t.check_constraint "json_valid(`settings`)", name: "settings"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "account_id"
    t.bigint "comment_id"
    t.string "aid", default: "", null: false
    t.string "name", default: "", null: false
    t.text "content", default: "", null: false
    t.bigint "likes_count", default: 0, null: false
    t.string "address", default: "", null: false
    t.boolean "public", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
    t.index ["aid"], name: "index_comments_on_aid", unique: true
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.boolean "public", default: true, null: false
    t.string "original_key", default: "", null: false
    t.text "variants", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_images_on_account_id"
    t.index ["aid"], name: "index_images_on_aid", unique: true
    t.check_constraint "json_valid(`variants`)", name: "variants"
  end

  create_table "inquiries", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", default: "", null: false
    t.string "subject", default: "", null: false
    t.text "content", default: "", null: false
    t.string "name", default: "", null: false
    t.string "address", default: "", null: false
    t.text "memo", default: "", null: false
    t.text "metadata", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "done", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_inquiries_on_aid", unique: true
    t.check_constraint "json_valid(`metadata`)", name: "metadata"
  end

  create_table "post_tags", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "account_id"
    t.string "aid", null: false
    t.string "thumbnail_original_key", default: "", null: false
    t.text "thumbnail_variants", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.string "title", default: "", null: false
    t.text "summary", default: "", null: false
    t.text "content", default: "", null: false
    t.bigint "likes_count", default: 0, null: false
    t.bigint "views_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.text "metadata", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.datetime "published_at"
    t.datetime "edited_at"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", limit: 1, default: 0, null: false
    t.index ["account_id"], name: "index_posts_on_account_id"
    t.index ["aid"], name: "index_posts_on_aid", unique: true
    t.check_constraint "json_valid(`metadata`)", name: "metadata"
    t.check_constraint "json_valid(`thumbnail_variants`)", name: "thumbnail_variants"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.string "session_digest", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sessions_on_account_id"
    t.index ["aid"], name: "index_sessions_on_aid", unique: true
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "public", default: false, null: false
    t.integer "posts_count", default: 0, null: false
    t.bigint "views_count", default: 0, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_tags_on_aid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "accounts"
  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "posts"
  add_foreign_key "images", "accounts"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "accounts"
  add_foreign_key "sessions", "accounts"
end
