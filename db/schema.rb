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

ActiveRecord::Schema.define(version: 20160317005314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis"

  create_table "announcements", force: :cascade do |t|
    t.text     "body"
    t.text     "heading"
    t.string   "type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.text     "description"
    t.boolean  "is_public"
    t.boolean  "is_active"
    t.datetime "deleted_at"
    t.string   "variety",           limit: 3
    t.string   "color",             limit: 7
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean  "is_initial",                    default: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id",             null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.text     "description"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,  default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.integer  "user_id"
    t.string   "role",             limit: 255, default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "lines", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.boolean  "is_active"
    t.datetime "deleted_at"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "origin",      limit: 255
    t.geometry "path",        limit: {:srid=>4326, :type=>"line_string"}
  end

  add_index "lines", ["category_id"], name: "index_lines_on_category_id", using: :btree
  add_index "lines", ["user_id"], name: "index_lines_on_user_id", using: :btree

  create_table "moderators_zones", force: :cascade do |t|
    t.integer "moderator_id"
    t.integer "zone_id"
  end

  add_index "moderators_zones", ["zone_id"], name: "index_moderators_zones_on_zone_id", using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "last_name"
    t.string   "first_name"
  end

  add_index "newsletters", ["email"], name: "index_newsletters_on_email", unique: true, using: :btree

  create_table "ratings", force: :cascade do |t|
    t.decimal  "rate"
    t.integer  "site_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["site_id"], name: "index_ratings_on_site_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "report_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "report_category_id"
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "aasm_state",           limit: 255
  end

  add_index "reports", ["report_category_id"], name: "index_reports_on_report_category_id", using: :btree

  create_table "reports_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports_reports", force: :cascade do |t|
    t.text     "description"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "user_id"
    t.string   "origin"
  end

  add_index "reports_reports", ["category_id"], name: "index_reports_reports_on_category_id", using: :btree
  add_index "reports_reports", ["sub_category_id"], name: "index_reports_reports_on_sub_category_id", using: :btree

  create_table "reports_states", force: :cascade do |t|
    t.string   "comment"
    t.string   "status_code"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports_statuses", force: :cascade do |t|
    t.string   "code"
    t.string   "label"
    t.string   "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "fa_icon"
    t.boolean  "is_final_state", default: false
  end

  create_table "reports_sub_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "reports_sub_categories", ["category_id"], name: "index_reports_sub_categories_on_category_id", using: :btree

  create_table "rides", force: :cascade do |t|
    t.string   "name",                                                             null: false
    t.text     "description"
    t.datetime "start",                                                            null: false
    t.datetime "end"
    t.geometry "path",                 limit: {:srid=>4326, :type=>"line_string"}, null: false
    t.integer  "user_id"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "rides", ["user_id"], name: "index_rides_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string    "name",                     limit: 255
    t.text      "description"
    t.boolean   "is_active",                                                                         default: true
    t.datetime  "deleted_at"
    t.integer   "category_id"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.integer   "user_id"
    t.boolean   "has_been_reviewed",                                                                 default: false
    t.string    "origin",                   limit: 255
    t.string    "picture_1_file_name"
    t.string    "picture_1_content_type"
    t.integer   "picture_1_file_size"
    t.datetime  "picture_1_updated_at"
    t.string    "picture_2_file_name"
    t.string    "picture_2_content_type"
    t.integer   "picture_2_file_size"
    t.datetime  "picture_2_updated_at"
    t.string    "picture_3_file_name"
    t.string    "picture_3_content_type"
    t.integer   "picture_3_file_size"
    t.datetime  "picture_3_updated_at"
    t.geography "lonlat",                   limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "custom_icon_file_name"
    t.string    "custom_icon_content_type"
    t.integer   "custom_icon_file_size"
    t.datetime  "custom_icon_updated_at"
  end

  add_index "sites", ["category_id"], name: "index_sites_on_category_id", using: :btree
  add_index "sites", ["user_id"], name: "index_sites_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_uid",           limit: 255
    t.string   "last_name",              limit: 255
    t.string   "first_name",             limit: 255
    t.boolean  "is_admin",                           default: false
    t.boolean  "is_moderator",                       default: false
    t.string   "token",                  limit: 255
    t.string   "locale",                 limit: 255, default: "en"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "receive_notifications",              default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zones", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.geometry "polygon",     limit: {:srid=>4326, :type=>"polygon"}
  end

  add_index "zones", ["user_id"], name: "index_zones_on_user_id", using: :btree

  add_foreign_key "rides", "users"
end
