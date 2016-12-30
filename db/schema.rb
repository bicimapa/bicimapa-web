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

ActiveRecord::Schema.define(version: 20160515020933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis_tiger_geocoder"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addr", primary_key: "gid", force: :cascade do |t|
    t.integer "tlid",      limit: 8
    t.string  "fromhn",    limit: 12
    t.string  "tohn",      limit: 12
    t.string  "side",      limit: 1
    t.string  "zip",       limit: 5
    t.string  "plus4",     limit: 4
    t.string  "fromtyp",   limit: 1
    t.string  "totyp",     limit: 1
    t.integer "fromarmid"
    t.integer "toarmid"
    t.string  "arid",      limit: 22
    t.string  "mtfcc",     limit: 5
    t.string  "statefp",   limit: 2
  end

  add_index "addr", ["tlid", "statefp"], name: "idx_tiger_addr_tlid_statefp", using: :btree
  add_index "addr", ["zip"], name: "idx_tiger_addr_zip", using: :btree

  create_table "addrfeat", primary_key: "gid", force: :cascade do |t|
    t.integer  "tlid",       limit: 8
    t.string   "statefp",    limit: 2,                                   null: false
    t.string   "aridl",      limit: 22
    t.string   "aridr",      limit: 22
    t.string   "linearid",   limit: 22
    t.string   "fullname",   limit: 100
    t.string   "lfromhn",    limit: 12
    t.string   "ltohn",      limit: 12
    t.string   "rfromhn",    limit: 12
    t.string   "rtohn",      limit: 12
    t.string   "zipl",       limit: 5
    t.string   "zipr",       limit: 5
    t.string   "edge_mtfcc", limit: 5
    t.string   "parityl",    limit: 1
    t.string   "parityr",    limit: 1
    t.string   "plus4l",     limit: 4
    t.string   "plus4r",     limit: 4
    t.string   "lfromtyp",   limit: 1
    t.string   "ltotyp",     limit: 1
    t.string   "rfromtyp",   limit: 1
    t.string   "rtotyp",     limit: 1
    t.string   "offsetl",    limit: 1
    t.string   "offsetr",    limit: 1
    t.geometry "the_geom",   limit: {:srid=>4269, :type=>"line_string"}
  end

  add_index "addrfeat", ["the_geom"], name: "idx_addrfeat_geom_gist", using: :gist
  add_index "addrfeat", ["tlid"], name: "idx_addrfeat_tlid", using: :btree
  add_index "addrfeat", ["zipl"], name: "idx_addrfeat_zipl", using: :btree
  add_index "addrfeat", ["zipr"], name: "idx_addrfeat_zipr", using: :btree

  create_table "announcements", force: :cascade do |t|
    t.text     "body"
    t.text     "heading"
    t.string   "type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  create_table "bg", primary_key: "bg_id", force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('bg_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "tractce",  limit: 6
    t.string   "blkgrpce", limit: 1
    t.string   "namelsad", limit: 13
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
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

  create_table "county", primary_key: "cntyidfp", force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('county_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "countyns", limit: 8
    t.string   "name",     limit: 100
    t.string   "namelsad", limit: 100
    t.string   "lsad",     limit: 2
    t.string   "classfp",  limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "csafp",    limit: 3
    t.string   "cbsafp",   limit: 5
    t.string   "metdivfp", limit: 5
    t.string   "funcstat", limit: 1
    t.integer  "aland",    limit: 8
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  add_index "county", ["countyfp"], name: "idx_tiger_county", using: :btree
  add_index "county", ["gid"], name: "uidx_county_gid", unique: true, using: :btree

  create_table "county_lookup", id: false, force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "co_code",            null: false
    t.string  "name",    limit: 90
  end

  add_index "county_lookup", ["state"], name: "county_lookup_state_idx", using: :btree

  create_table "countysub_lookup", id: false, force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "co_code",            null: false
    t.string  "county",  limit: 90
    t.integer "cs_code",            null: false
    t.string  "name",    limit: 90
  end

  add_index "countysub_lookup", ["state"], name: "countysub_lookup_state_idx", using: :btree

  create_table "cousub", primary_key: "cosbidfp", force: :cascade do |t|
    t.integer  "gid",                                                                   default: "nextval('cousub_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "cousubfp", limit: 5
    t.string   "cousubns", limit: 8
    t.string   "name",     limit: 100
    t.string   "namelsad", limit: 100
    t.string   "lsad",     limit: 2
    t.string   "classfp",  limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "cnectafp", limit: 3
    t.string   "nectafp",  limit: 5
    t.string   "nctadvfp", limit: 5
    t.string   "funcstat", limit: 1
    t.decimal  "aland",                                                  precision: 14
    t.decimal  "awater",                                                 precision: 14
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  add_index "cousub", ["gid"], name: "uidx_cousub_gid", unique: true, using: :btree
  add_index "cousub", ["the_geom"], name: "tige_cousub_the_geom_gist", using: :gist

  create_table "direction_lookup", primary_key: "name", force: :cascade do |t|
    t.string "abbrev", limit: 3
  end

  add_index "direction_lookup", ["abbrev"], name: "direction_lookup_abbrev_idx", using: :btree

  create_table "edges", primary_key: "gid", force: :cascade do |t|
    t.string   "statefp",    limit: 2
    t.string   "countyfp",   limit: 3
    t.integer  "tlid",       limit: 8
    t.decimal  "tfidl",                                                        precision: 10
    t.decimal  "tfidr",                                                        precision: 10
    t.string   "mtfcc",      limit: 5
    t.string   "fullname",   limit: 100
    t.string   "smid",       limit: 22
    t.string   "lfromadd",   limit: 12
    t.string   "ltoadd",     limit: 12
    t.string   "rfromadd",   limit: 12
    t.string   "rtoadd",     limit: 12
    t.string   "zipl",       limit: 5
    t.string   "zipr",       limit: 5
    t.string   "featcat",    limit: 1
    t.string   "hydroflg",   limit: 1
    t.string   "railflg",    limit: 1
    t.string   "roadflg",    limit: 1
    t.string   "olfflg",     limit: 1
    t.string   "passflg",    limit: 1
    t.string   "divroad",    limit: 1
    t.string   "exttyp",     limit: 1
    t.string   "ttyp",       limit: 1
    t.string   "deckedroad", limit: 1
    t.string   "artpath",    limit: 1
    t.string   "persist",    limit: 1
    t.string   "gcseflg",    limit: 1
    t.string   "offsetl",    limit: 1
    t.string   "offsetr",    limit: 1
    t.decimal  "tnidf",                                                        precision: 10
    t.decimal  "tnidt",                                                        precision: 10
    t.geometry "the_geom",   limit: {:srid=>4269, :type=>"multi_line_string"}
  end

  add_index "edges", ["countyfp"], name: "idx_tiger_edges_countyfp", using: :btree
  add_index "edges", ["the_geom"], name: "idx_tiger_edges_the_geom_gist", using: :gist
  add_index "edges", ["tlid"], name: "idx_edges_tlid", using: :btree

  create_table "faces", primary_key: "gid", force: :cascade do |t|
    t.decimal  "tfid",                                                     precision: 10
    t.string   "statefp00",  limit: 2
    t.string   "countyfp00", limit: 3
    t.string   "tractce00",  limit: 6
    t.string   "blkgrpce00", limit: 1
    t.string   "blockce00",  limit: 4
    t.string   "cousubfp00", limit: 5
    t.string   "submcdfp00", limit: 5
    t.string   "conctyfp00", limit: 5
    t.string   "placefp00",  limit: 5
    t.string   "aiannhfp00", limit: 5
    t.string   "aiannhce00", limit: 4
    t.string   "comptyp00",  limit: 1
    t.string   "trsubfp00",  limit: 5
    t.string   "trsubce00",  limit: 3
    t.string   "anrcfp00",   limit: 5
    t.string   "elsdlea00",  limit: 5
    t.string   "scsdlea00",  limit: 5
    t.string   "unsdlea00",  limit: 5
    t.string   "uace00",     limit: 5
    t.string   "cd108fp",    limit: 2
    t.string   "sldust00",   limit: 3
    t.string   "sldlst00",   limit: 3
    t.string   "vtdst00",    limit: 6
    t.string   "zcta5ce00",  limit: 5
    t.string   "tazce00",    limit: 6
    t.string   "ugace00",    limit: 5
    t.string   "puma5ce00",  limit: 5
    t.string   "statefp",    limit: 2
    t.string   "countyfp",   limit: 3
    t.string   "tractce",    limit: 6
    t.string   "blkgrpce",   limit: 1
    t.string   "blockce",    limit: 4
    t.string   "cousubfp",   limit: 5
    t.string   "submcdfp",   limit: 5
    t.string   "conctyfp",   limit: 5
    t.string   "placefp",    limit: 5
    t.string   "aiannhfp",   limit: 5
    t.string   "aiannhce",   limit: 4
    t.string   "comptyp",    limit: 1
    t.string   "trsubfp",    limit: 5
    t.string   "trsubce",    limit: 3
    t.string   "anrcfp",     limit: 5
    t.string   "ttractce",   limit: 6
    t.string   "tblkgpce",   limit: 1
    t.string   "elsdlea",    limit: 5
    t.string   "scsdlea",    limit: 5
    t.string   "unsdlea",    limit: 5
    t.string   "uace",       limit: 5
    t.string   "cd111fp",    limit: 2
    t.string   "sldust",     limit: 3
    t.string   "sldlst",     limit: 3
    t.string   "vtdst",      limit: 6
    t.string   "zcta5ce",    limit: 5
    t.string   "tazce",      limit: 6
    t.string   "ugace",      limit: 5
    t.string   "puma5ce",    limit: 5
    t.string   "csafp",      limit: 3
    t.string   "cbsafp",     limit: 5
    t.string   "metdivfp",   limit: 5
    t.string   "cnectafp",   limit: 3
    t.string   "nectafp",    limit: 5
    t.string   "nctadvfp",   limit: 5
    t.string   "lwflag",     limit: 1
    t.string   "offset",     limit: 1
    t.float    "atotal"
    t.string   "intptlat",   limit: 11
    t.string   "intptlon",   limit: 12
    t.geometry "the_geom",   limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  add_index "faces", ["countyfp"], name: "idx_tiger_faces_countyfp", using: :btree
  add_index "faces", ["tfid"], name: "idx_tiger_faces_tfid", using: :btree
  add_index "faces", ["the_geom"], name: "tiger_faces_the_geom_gist", using: :gist

  create_table "featnames", primary_key: "gid", force: :cascade do |t|
    t.integer "tlid",       limit: 8
    t.string  "fullname",   limit: 100
    t.string  "name",       limit: 100
    t.string  "predirabrv", limit: 15
    t.string  "pretypabrv", limit: 50
    t.string  "prequalabr", limit: 15
    t.string  "sufdirabrv", limit: 15
    t.string  "suftypabrv", limit: 50
    t.string  "sufqualabr", limit: 15
    t.string  "predir",     limit: 2
    t.string  "pretyp",     limit: 3
    t.string  "prequal",    limit: 2
    t.string  "sufdir",     limit: 2
    t.string  "suftyp",     limit: 3
    t.string  "sufqual",    limit: 2
    t.string  "linearid",   limit: 22
    t.string  "mtfcc",      limit: 5
    t.string  "paflag",     limit: 1
    t.string  "statefp",    limit: 2
  end

  add_index "featnames", ["tlid", "statefp"], name: "idx_tiger_featnames_tlid_statefp", using: :btree

  create_table "geocode_settings", primary_key: "name", force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "geocode_settings_default", primary_key: "name", force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

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

  create_table "loader_lookuptables", primary_key: "lookup_name", force: :cascade do |t|
    t.integer "process_order",                   default: 1000,  null: false
    t.text    "table_name"
    t.boolean "single_mode",                     default: true,  null: false
    t.boolean "load",                            default: true,  null: false
    t.boolean "level_county",                    default: false, null: false
    t.boolean "level_state",                     default: false, null: false
    t.boolean "level_nation",                    default: false, null: false
    t.text    "post_load_process"
    t.boolean "single_geom_mode",                default: false
    t.string  "insert_mode",           limit: 1, default: "c",   null: false
    t.text    "pre_load_process"
    t.text    "columns_exclude",                                              array: true
    t.text    "website_root_override"
  end

  create_table "loader_platform", primary_key: "os", force: :cascade do |t|
    t.text "declare_sect"
    t.text "pgbin"
    t.text "wget"
    t.text "unzip_command"
    t.text "psql"
    t.text "path_sep"
    t.text "loader"
    t.text "environ_set_command"
    t.text "county_process_command"
  end

  create_table "loader_variables", primary_key: "tiger_year", force: :cascade do |t|
    t.text "website_root"
    t.text "staging_fold"
    t.text "data_schema"
    t.text "staging_schema"
  end

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

  create_table "pagc_gaz", force: :cascade do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_lex", force: :cascade do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_rules", force: :cascade do |t|
    t.text    "rule"
    t.boolean "is_custom", default: true
  end

  create_table "place", primary_key: "plcidfp", force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('place_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2
    t.string   "placefp",  limit: 5
    t.string   "placens",  limit: 8
    t.string   "name",     limit: 100
    t.string   "namelsad", limit: 100
    t.string   "lsad",     limit: 2
    t.string   "classfp",  limit: 2
    t.string   "cpi",      limit: 1
    t.string   "pcicbsa",  limit: 1
    t.string   "pcinecta", limit: 1
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.integer  "aland",    limit: 8
    t.integer  "awater",   limit: 8
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  add_index "place", ["gid"], name: "uidx_tiger_place_gid", unique: true, using: :btree
  add_index "place", ["the_geom"], name: "tiger_place_the_geom_gist", using: :gist

  create_table "place_lookup", id: false, force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "pl_code",            null: false
    t.string  "name",    limit: 90
  end

  add_index "place_lookup", ["state"], name: "place_lookup_state_idx", using: :btree

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
    t.text      "description"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.integer   "category_id"
    t.integer   "sub_category_id"
    t.string    "photo_file_name",    limit: 255
    t.string    "photo_content_type", limit: 255
    t.integer   "photo_file_size"
    t.datetime  "photo_updated_at"
    t.integer   "user_id"
    t.string    "origin"
    t.geography "lonlat",             limit: {:srid=>4326, :type=>"point", :geographic=>true}
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

  create_table "secondary_unit_lookup", primary_key: "name", force: :cascade do |t|
    t.string "abbrev", limit: 5
  end

  add_index "secondary_unit_lookup", ["abbrev"], name: "secondary_unit_lookup_abbrev_idx", using: :btree

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

  create_table "state", primary_key: "statefp", force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('state_gid_seq'::regclass)", null: false
    t.string   "region",   limit: 2
    t.string   "division", limit: 2
    t.string   "statens",  limit: 8
    t.string   "stusps",   limit: 2,                                                                                    null: false
    t.string   "name",     limit: 100
    t.string   "lsad",     limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.integer  "aland",    limit: 8
    t.integer  "awater",   limit: 8
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  add_index "state", ["gid"], name: "uidx_tiger_state_gid", unique: true, using: :btree
  add_index "state", ["stusps"], name: "uidx_tiger_state_stusps", unique: true, using: :btree
  add_index "state", ["the_geom"], name: "idx_tiger_state_the_geom_gist", using: :gist

  create_table "state_lookup", primary_key: "st_code", force: :cascade do |t|
    t.string "name",    limit: 40
    t.string "abbrev",  limit: 3
    t.string "statefp", limit: 2
  end

  add_index "state_lookup", ["abbrev"], name: "state_lookup_abbrev_key", unique: true, using: :btree
  add_index "state_lookup", ["name"], name: "state_lookup_name_key", unique: true, using: :btree
  add_index "state_lookup", ["statefp"], name: "state_lookup_statefp_key", unique: true, using: :btree

  create_table "street_type_lookup", primary_key: "name", force: :cascade do |t|
    t.string  "abbrev", limit: 50
    t.boolean "is_hw",             default: false, null: false
  end

  add_index "street_type_lookup", ["abbrev"], name: "street_type_lookup_abbrev_idx", using: :btree

  create_table "tabblock", primary_key: "tabblock_id", force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('tabblock_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "tractce",  limit: 6
    t.string   "blockce",  limit: 4
    t.string   "name",     limit: 20
    t.string   "mtfcc",    limit: 5
    t.string   "ur",       limit: 1
    t.string   "uace",     limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  create_table "tract", primary_key: "tract_id", force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('tract_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "tractce",  limit: 6
    t.string   "name",     limit: 7
    t.string   "namelsad", limit: 20
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

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

  create_table "zcta5", id: false, force: :cascade do |t|
    t.integer  "gid",                                                    default: "nextval('zcta5_gid_seq'::regclass)", null: false
    t.string   "statefp",  limit: 2,                                                                                    null: false
    t.string   "zcta5ce",  limit: 5,                                                                                    null: false
    t.string   "classfp",  limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.string   "partflg",  limit: 1
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  add_index "zcta5", ["gid"], name: "uidx_tiger_zcta5_gid", unique: true, using: :btree

  create_table "zip_lookup", primary_key: "zip", force: :cascade do |t|
    t.integer "st_code"
    t.string  "state",   limit: 2
    t.integer "co_code"
    t.string  "county",  limit: 90
    t.integer "cs_code"
    t.string  "cousub",  limit: 90
    t.integer "pl_code"
    t.string  "place",   limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_all", id: false, force: :cascade do |t|
    t.integer "zip"
    t.integer "st_code"
    t.string  "state",   limit: 2
    t.integer "co_code"
    t.string  "county",  limit: 90
    t.integer "cs_code"
    t.string  "cousub",  limit: 90
    t.integer "pl_code"
    t.string  "place",   limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_base", primary_key: "zip", force: :cascade do |t|
    t.string "state",   limit: 40
    t.string "county",  limit: 90
    t.string "city",    limit: 90
    t.string "statefp", limit: 2
  end

  create_table "zip_state", id: false, force: :cascade do |t|
    t.string "zip",     limit: 5, null: false
    t.string "stusps",  limit: 2, null: false
    t.string "statefp", limit: 2
  end

  create_table "zip_state_loc", id: false, force: :cascade do |t|
    t.string "zip",     limit: 5,   null: false
    t.string "stusps",  limit: 2,   null: false
    t.string "statefp", limit: 2
    t.string "place",   limit: 100, null: false
  end

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
