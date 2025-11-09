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

ActiveRecord::Schema[8.0].define(version: 12) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", limit: 14, null: false
    t.string "name", null: false
    t.string "name_id", null: false
    t.text "description", default: "", null: false
    t.datetime "birthday"
    t.string "email"
    t.boolean "email_verified", default: false, null: false
    t.integer "visibility", limit: 1, default: 0, null: false
    t.string "password_digest"
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "icon_id"
    t.index ["aid"], name: "index_accounts_on_aid", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["icon_id"], name: "index_accounts_on_icon_id"
    t.index ["name_id"], name: "index_accounts_on_name_id", unique: true
    t.check_constraint "json_valid(`meta`)", name: "meta"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "account_id"
    t.bigint "comment_id"
    t.string "aid", limit: 14, null: false
    t.string "name", null: false
    t.text "content", null: false
    t.string "address", default: "", null: false
    t.integer "visibility", limit: 1, default: 0, null: false
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
    t.index ["aid"], name: "index_comments_on_aid", unique: true
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.check_constraint "json_valid(`meta`)", name: "meta"
  end

  create_table "follows", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "followed_id", null: false
    t.bigint "follower_id", null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id", "follower_id"], name: "index_follows_on_followed_id_and_follower_id", unique: true
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "account_id"
    t.string "aid", limit: 14, null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.string "original_ext", null: false
    t.text "variants", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.integer "visibility", limit: 1, default: 0, null: false
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_images_on_account_id"
    t.index ["aid"], name: "index_images_on_aid", unique: true
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`variants`)", name: "variants"
  end

  create_table "oauth_accounts", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", limit: 14, null: false
    t.bigint "account_id", null: false
    t.integer "provider", limit: 1, null: false
    t.string "uid", null: false
    t.text "access_token", null: false
    t.text "refresh_token", null: false
    t.datetime "expires_at", null: false
    t.datetime "fetched_at", null: false
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_oauth_accounts_on_account_id"
    t.index ["aid"], name: "index_oauth_accounts_on_aid", unique: true
    t.index ["provider", "uid"], name: "index_oauth_accounts_on_provider_and_uid", unique: true
    t.check_constraint "json_valid(`meta`)", name: "meta"
  end

  create_table "post_images", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "image_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_post_images_on_image_id"
    t.index ["post_id"], name: "index_post_images_on_post_id"
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
    t.string "aid", limit: 14, null: false
    t.string "name_id", null: false
    t.bigint "thumbnail_id"
    t.string "title", default: "", null: false
    t.text "summary", default: "", null: false
    t.text "content", default: "", null: false
    t.datetime "published_at"
    t.datetime "edited_at"
    t.integer "visibility", limit: 1, default: 0, null: false
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_posts_on_account_id"
    t.index ["aid"], name: "index_posts_on_aid", unique: true
    t.index ["name_id"], name: "index_posts_on_name_id", unique: true
    t.index ["thumbnail_id"], name: "index_posts_on_thumbnail_id"
    t.check_constraint "json_valid(`meta`)", name: "meta"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", limit: 14, null: false
    t.bigint "account_id", null: false
    t.string "name", default: "", null: false
    t.string "token_lookup", null: false
    t.string "token_digest", null: false
    t.datetime "token_expires_at", null: false
    t.datetime "token_generated_at", null: false
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sessions_on_account_id"
    t.index ["aid"], name: "index_sessions_on_aid", unique: true
    t.index ["token_lookup"], name: "index_sessions_on_token_lookup", unique: true
    t.check_constraint "json_valid(`meta`)", name: "meta"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "aid", limit: 14, null: false
    t.string "name", null: false
    t.string "name_id", null: false
    t.text "description", default: "", null: false
    t.integer "visibility", limit: 1, default: 0, null: false
    t.text "meta", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_tags_on_aid", unique: true
    t.index ["name_id"], name: "index_tags_on_name_id", unique: true
    t.check_constraint "json_valid(`meta`)", name: "meta"
  end

  create_table "view_logs", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "viewable_type", null: false
    t.bigint "viewable_id", null: false
    t.bigint "account_id"
    t.string "ip", limit: 45
    t.text "user_agent"
    t.text "referer"
    t.string "session_id"
    t.string "device_type"
    t.string "browser"
    t.string "os"
    t.boolean "is_bot", default: false
    t.datetime "viewed_at", default: -> { "current_timestamp(6)" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_view_logs_on_account_id"
    t.index ["ip", "viewed_at"], name: "index_view_logs_on_ip_and_viewed_at"
    t.index ["viewable_type", "viewable_id"], name: "index_view_logs_on_viewable_type_and_viewable_id"
  end

  add_foreign_key "accounts", "images", column: "icon_id"
  add_foreign_key "comments", "accounts"
  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "posts"
  add_foreign_key "follows", "accounts", column: "followed_id"
  add_foreign_key "follows", "accounts", column: "follower_id"
  add_foreign_key "images", "accounts"
  add_foreign_key "oauth_accounts", "accounts"
  add_foreign_key "post_images", "images"
  add_foreign_key "post_images", "posts"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "accounts"
  add_foreign_key "posts", "images", column: "thumbnail_id"
  add_foreign_key "sessions", "accounts"
  add_foreign_key "view_logs", "accounts"
end
