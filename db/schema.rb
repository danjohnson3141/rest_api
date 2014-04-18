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

ActiveRecord::Schema.define(version: 20140414204332) do

  create_table "app_admin_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_admin_users", ["created_by"], name: "index_app_admin_users_on_created_by", using: :btree
  add_index "app_admin_users", ["updated_by"], name: "index_app_admin_users_on_updated_by", using: :btree
  add_index "app_admin_users", ["user_id"], name: "index_app_admin_users_on_user_id", using: :btree

  create_table "app_emails", force: true do |t|
    t.string   "email_from"
    t.string   "email_subject"
    t.text     "email_body"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_emails", ["created_by"], name: "index_app_emails_on_created_by", using: :btree
  add_index "app_emails", ["updated_by"], name: "index_app_emails_on_updated_by", using: :btree

  create_table "app_label_dictionaries", force: true do |t|
    t.string   "key",               null: false
    t.string   "name"
    t.string   "name_plural"
    t.string   "description"
    t.integer  "app_label_page_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_label_dictionaries", ["app_label_page_id", "key"], name: "index_app_label_dictionaries_on_key_and_app_label_page_id", unique: true, using: :btree
  add_index "app_label_dictionaries", ["app_label_page_id"], name: "index_app_label_dictionaries_on_app_label_page_id", using: :btree
  add_index "app_label_dictionaries", ["created_by"], name: "index_app_label_dictionaries_on_created_by", using: :btree
  add_index "app_label_dictionaries", ["updated_by"], name: "index_app_label_dictionaries_on_updated_by", using: :btree

  create_table "app_label_pages", force: true do |t|
    t.string   "name",          limit: 50
    t.string   "description"
    t.boolean  "auth_required",            default: true, null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_label_pages", ["created_by"], name: "index_app_label_pages_on_created_by", using: :btree
  add_index "app_label_pages", ["name"], name: "index_app_label_pages_on_name", unique: true, using: :btree
  add_index "app_label_pages", ["updated_by"], name: "index_app_label_pages_on_updated_by", using: :btree

  create_table "app_label_translations", force: true do |t|
    t.integer  "app_label_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  add_index "app_label_translations", ["app_label_id"], name: "index_app_label_translations_on_app_label_id", using: :btree
  add_index "app_label_translations", ["locale"], name: "index_app_label_translations_on_locale", using: :btree

  create_table "app_labels", force: true do |t|
    t.string   "label"
    t.string   "label_plural"
    t.integer  "event_id"
    t.integer  "app_label_dictionary_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_labels", ["app_label_dictionary_id"], name: "index_app_labels_on_app_label_dictionary_id", using: :btree
  add_index "app_labels", ["created_by"], name: "index_app_labels_on_created_by", using: :btree
  add_index "app_labels", ["event_id"], name: "index_app_labels_on_event_id", using: :btree
  add_index "app_labels", ["updated_by"], name: "index_app_labels_on_updated_by", using: :btree

  create_table "app_languages", force: true do |t|
    t.string   "name",        limit: 50
    t.string   "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_languages", ["created_by"], name: "index_app_languages_on_created_by", using: :btree
  add_index "app_languages", ["updated_by"], name: "index_app_languages_on_updated_by", using: :btree

  create_table "app_setting_dependencies", force: true do |t|
    t.integer  "app_setting_option_id",           null: false
    t.integer  "dependent_app_setting_option_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_setting_dependencies", ["app_setting_option_id"], name: "index_app_setting_dependencies_on_app_setting_option_id", using: :btree
  add_index "app_setting_dependencies", ["dependent_app_setting_option_id"], name: "dependent_app_setting_option_id", using: :btree

  create_table "app_setting_options", force: true do |t|
    t.string   "name",                null: false
    t.string   "description",         null: false
    t.integer  "app_setting_type_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_setting_options", ["app_setting_type_id"], name: "index_app_setting_options_on_app_setting_type_id", using: :btree
  add_index "app_setting_options", ["created_by"], name: "app_setting_options_created_by_fk", using: :btree
  add_index "app_setting_options", ["name", "description", "app_setting_type_id"], name: "index_app_setting_options_on_name_and_desc_and_app_setting_type", unique: true, using: :btree
  add_index "app_setting_options", ["updated_by"], name: "app_setting_options_updated_by_fk", using: :btree

  create_table "app_setting_types", force: true do |t|
    t.string   "name",        limit: 50, null: false
    t.string   "description",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_setting_types", ["name"], name: "index_app_setting_types_on_name", unique: true, using: :btree

  create_table "app_settings", force: true do |t|
    t.integer  "app_setting_option_id", null: false
    t.boolean  "app_level_setting"
    t.integer  "event_id"
    t.integer  "group_id"
    t.integer  "user_role_id"
    t.integer  "user_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["app_setting_option_id", "app_level_setting"], name: "unique_app_setting_option_id", unique: true, using: :btree
  add_index "app_settings", ["app_setting_option_id", "event_id"], name: "unique_event_id", unique: true, using: :btree
  add_index "app_settings", ["app_setting_option_id", "group_id"], name: "unique_group_id", unique: true, using: :btree
  add_index "app_settings", ["app_setting_option_id", "user_id"], name: "unique_user_id", unique: true, using: :btree
  add_index "app_settings", ["app_setting_option_id", "user_role_id"], name: "unique_user_role_id", unique: true, using: :btree
  add_index "app_settings", ["app_setting_option_id"], name: "index_app_settings_on_app_setting_option_id", using: :btree
  add_index "app_settings", ["created_by"], name: "app_settings_created_by_fk", using: :btree
  add_index "app_settings", ["event_id"], name: "index_app_settings_on_event_id", using: :btree
  add_index "app_settings", ["group_id"], name: "index_app_settings_on_group_id", using: :btree
  add_index "app_settings", ["updated_by"], name: "app_settings_updated_by_fk", using: :btree
  add_index "app_settings", ["user_id"], name: "index_app_settings_on_user_id", using: :btree
  add_index "app_settings", ["user_role_id"], name: "index_app_settings_on_user_role_id", using: :btree

  create_table "app_supports", force: true do |t|
    t.text     "body"
    t.string   "email"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_supports", ["created_by"], name: "index_app_supports_on_created_by", using: :btree
  add_index "app_supports", ["updated_by"], name: "index_app_supports_on_updated_by", using: :btree

  create_table "banner_ads", force: true do |t|
    t.text     "graphic_link"
    t.integer  "sponsor_id"
    t.string   "link_url",     limit: 100
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banner_ads", ["created_by"], name: "index_banner_ads_on_created_by", using: :btree
  add_index "banner_ads", ["sponsor_id"], name: "index_banner_ads_on_sponsor_id", using: :btree
  add_index "banner_ads", ["updated_by"], name: "index_banner_ads_on_updated_by", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name",         limit: 100
    t.string   "abbreviation", limit: 50
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["created_by"], name: "index_countries_on_created_by", using: :btree
  add_index "countries", ["updated_by"], name: "index_countries_on_updated_by", using: :btree

  create_table "event_bookmarks", force: true do |t|
    t.integer  "event_user_id"
    t.integer  "event_speaker_id"
    t.integer  "event_session_id"
    t.integer  "sponsor_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_bookmarks", ["created_by"], name: "index_user_event_bookmarks_on_created_by", using: :btree
  add_index "event_bookmarks", ["event_session_id"], name: "index_user_event_bookmarks_on_event_session_id", using: :btree
  add_index "event_bookmarks", ["event_speaker_id"], name: "index_user_event_bookmarks_on_event_speaker_id", using: :btree
  add_index "event_bookmarks", ["event_user_id"], name: "index_user_event_bookmarks_on_event_user_id", using: :btree
  add_index "event_bookmarks", ["sponsor_id"], name: "index_user_event_bookmarks_on_event_sponsor_id", using: :btree
  add_index "event_bookmarks", ["updated_by"], name: "index_user_event_bookmarks_on_updated_by", using: :btree

  create_table "event_evaluations", force: true do |t|
    t.string   "survey_link"
    t.string   "name"
    t.integer  "display_rank"
    t.integer  "event_id"
    t.integer  "user_role_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_evaluations", ["created_by"], name: "index_event_evaluations_on_created_by", using: :btree
  add_index "event_evaluations", ["event_id"], name: "index_event_evaluations_on_event_id", using: :btree
  add_index "event_evaluations", ["updated_by"], name: "index_event_evaluations_on_updated_by", using: :btree
  add_index "event_evaluations", ["user_role_id"], name: "event_evaluations_user_role_id_fk", using: :btree

  create_table "event_followers", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_followers", ["created_by"], name: "index_event_followers_on_created_by", using: :btree
  add_index "event_followers", ["event_id"], name: "index_event_followers_on_event_id", using: :btree
  add_index "event_followers", ["updated_by"], name: "index_event_followers_on_updated_by", using: :btree
  add_index "event_followers", ["user_id"], name: "index_event_followers_on_user_id", using: :btree

  create_table "event_leaderboard_options", force: true do |t|
    t.string   "name",        limit: 30
    t.string   "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_leaderboard_options", ["created_by"], name: "index_event_leaderboard_options_on_created_by", using: :btree
  add_index "event_leaderboard_options", ["updated_by"], name: "index_event_leaderboard_options_on_updated_by", using: :btree

  create_table "event_leaderboards", force: true do |t|
    t.integer  "points_allocated"
    t.integer  "event_leaderboard_option_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_leaderboards", ["created_by"], name: "index_event_leaderboards_on_created_by", using: :btree
  add_index "event_leaderboards", ["event_leaderboard_option_id"], name: "index_event_leaderboards_on_event_leaderboard_option_id", using: :btree
  add_index "event_leaderboards", ["updated_by"], name: "index_event_leaderboards_on_updated_by", using: :btree

  create_table "event_notes", force: true do |t|
    t.text     "body"
    t.integer  "event_user_id"
    t.integer  "event_speaker_id"
    t.integer  "event_session_id"
    t.integer  "sponsor_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_notes", ["created_by"], name: "index_user_event_notes_on_created_by", using: :btree
  add_index "event_notes", ["event_session_id"], name: "index_user_event_notes_on_event_session_id", using: :btree
  add_index "event_notes", ["event_speaker_id"], name: "index_user_event_notes_on_event_speaker_id", using: :btree
  add_index "event_notes", ["event_user_id"], name: "index_user_event_notes_on_event_user_id", using: :btree
  add_index "event_notes", ["sponsor_id"], name: "index_user_event_notes_on_event_sponsor_id", using: :btree
  add_index "event_notes", ["updated_by"], name: "index_user_event_notes_on_updated_by", using: :btree

  create_table "event_registration_statuses", force: true do |t|
    t.string   "key",                     limit: 50
    t.integer  "app_label_dictionary_id",            null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_registration_statuses", ["app_label_dictionary_id"], name: "event_registration_statuses_app_label_dictionary_id_fk", using: :btree
  add_index "event_registration_statuses", ["created_by"], name: "index_event_registration_statuses_on_created_by", using: :btree
  add_index "event_registration_statuses", ["key"], name: "index_event_registration_statuses_on_key", unique: true, using: :btree
  add_index "event_registration_statuses", ["updated_by"], name: "index_event_registration_statuses_on_updated_by", using: :btree

  create_table "event_session_evaluations", force: true do |t|
    t.string   "survey_link"
    t.string   "name"
    t.integer  "display_rank"
    t.integer  "event_session_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_session_evaluations", ["created_by"], name: "index_event_session_evaluations_on_created_by", using: :btree
  add_index "event_session_evaluations", ["event_session_id"], name: "index_event_session_evaluations_on_event_session_id", using: :btree
  add_index "event_session_evaluations", ["updated_by"], name: "index_event_session_evaluations_on_updated_by", using: :btree

  create_table "event_sessions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.string   "track_name",        limit: 100
    t.string   "session_type",      limit: 100
    t.string   "room_name",         limit: 100
    t.boolean  "is_comments_on",                default: false, null: false
    t.integer  "sponsor_id"
    t.integer  "event_id"
    t.integer  "breakout_group_id"
    t.integer  "display_rank"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_sessions", ["breakout_group_id"], name: "event_sessions_breakout_group_id_fk", using: :btree
  add_index "event_sessions", ["created_by"], name: "index_event_sessions_on_created_by", using: :btree
  add_index "event_sessions", ["event_id"], name: "event_sessions_event_id_fk", using: :btree
  add_index "event_sessions", ["sponsor_id"], name: "index_event_sessions_on_sponsor_id", using: :btree
  add_index "event_sessions", ["updated_by"], name: "index_event_sessions_on_updated_by", using: :btree

  create_table "event_speakers", force: true do |t|
    t.string   "first_name",        limit: 100
    t.string   "last_name",         limit: 100
    t.string   "title"
    t.string   "organization_name"
    t.text     "bio"
    t.string   "speaker_type",      limit: 50
    t.boolean  "moderator",                     default: false, null: false
    t.integer  "user_id"
    t.integer  "event_session_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_speakers", ["created_by"], name: "index_event_speakers_on_created_by", using: :btree
  add_index "event_speakers", ["event_session_id"], name: "index_event_speakers_on_event_session_id", using: :btree
  add_index "event_speakers", ["updated_by"], name: "index_event_speakers_on_updated_by", using: :btree
  add_index "event_speakers", ["user_id"], name: "index_event_speakers_on_user_id", using: :btree

  create_table "event_staff_users", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "display_rank"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_staff_users", ["created_by"], name: "event_staff_users_created_by_fk", using: :btree
  add_index "event_staff_users", ["event_id"], name: "index_event_staff_users_on_event_id", using: :btree
  add_index "event_staff_users", ["updated_by"], name: "event_staff_users_updated_by_fk", using: :btree
  add_index "event_staff_users", ["user_id"], name: "index_event_staff_users_on_user_id", using: :btree

  create_table "event_user_schedules", force: true do |t|
    t.integer  "event_session_id"
    t.integer  "event_user_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_user_schedules", ["created_by"], name: "index_event_user_schedules_on_created_by", using: :btree
  add_index "event_user_schedules", ["event_session_id"], name: "index_event_user_schedules_on_event_session_id", using: :btree
  add_index "event_user_schedules", ["event_user_id"], name: "index_event_user_schedules_on_event_user_id", using: :btree
  add_index "event_user_schedules", ["updated_by"], name: "index_event_user_schedules_on_updated_by", using: :btree

  create_table "event_users", force: true do |t|
    t.integer  "event_registration_status_id", null: false
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "sponsor_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_users", ["created_by"], name: "index_event_users_on_created_by", using: :btree
  add_index "event_users", ["event_id", "user_id"], name: "index_event_users_on_event_id_and_user_id", unique: true, using: :btree
  add_index "event_users", ["event_id"], name: "index_event_users_on_event_id", using: :btree
  add_index "event_users", ["event_registration_status_id"], name: "index_event_users_on_event_registration_status_id", using: :btree
  add_index "event_users", ["sponsor_id"], name: "index_event_users_on_sponsor_id", using: :btree
  add_index "event_users", ["updated_by"], name: "index_event_users_on_updated_by", using: :btree
  add_index "event_users", ["user_id"], name: "index_event_users_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name",                   null: false
    t.date     "begin_date",             null: false
    t.date     "end_date",               null: false
    t.string   "venue_name"
    t.string   "address"
    t.string   "state",       limit: 4
    t.string   "postal_code", limit: 20
    t.integer  "country_id"
    t.integer  "timezone_id"
    t.integer  "group_id",               null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["country_id"], name: "index_events_on_country_id", using: :btree
  add_index "events", ["created_by"], name: "index_events_on_created_by", using: :btree
  add_index "events", ["group_id"], name: "index_events_on_group_id", using: :btree
  add_index "events", ["timezone_id"], name: "index_events_on_timezone_id", using: :btree
  add_index "events", ["updated_by"], name: "index_events_on_updated_by", using: :btree

  create_table "featured_posts", force: true do |t|
    t.integer  "post_id",    null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "featured_posts", ["created_by"], name: "index_featured_posts_on_created_by", using: :btree
  add_index "featured_posts", ["post_id"], name: "index_featured_posts_on_post_id", using: :btree
  add_index "featured_posts", ["updated_by"], name: "index_featured_posts_on_updated_by", using: :btree

  create_table "group_invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_invites", ["created_by"], name: "index_group_invites_on_created_by", using: :btree
  add_index "group_invites", ["group_id", "user_id"], name: "index_group_invites_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_invites", ["group_id"], name: "index_group_invites_on_group_id", using: :btree
  add_index "group_invites", ["updated_by"], name: "index_group_invites_on_updated_by", using: :btree
  add_index "group_invites", ["user_id"], name: "index_group_invites_on_user_id", using: :btree

  create_table "group_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_members", ["created_by"], name: "index_group_members_on_created_by", using: :btree
  add_index "group_members", ["group_id", "user_id"], name: "index_group_members_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id", using: :btree
  add_index "group_members", ["updated_by"], name: "index_group_members_on_updated_by", using: :btree
  add_index "group_members", ["user_id"], name: "index_group_members_on_user_id", using: :btree

  create_table "group_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "is_approved", default: false, null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_requests", ["created_by"], name: "index_group_requests_on_created_by", using: :btree
  add_index "group_requests", ["group_id", "user_id"], name: "index_group_requests_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_requests", ["group_id"], name: "index_group_requests_on_group_id", using: :btree
  add_index "group_requests", ["updated_by"], name: "index_group_requests_on_updated_by", using: :btree
  add_index "group_requests", ["user_id"], name: "index_group_requests_on_user_id", using: :btree

  create_table "group_types", force: true do |t|
    t.string   "name",                  limit: 50
    t.string   "description",           limit: 100
    t.boolean  "is_group_visible",                  default: false, null: false
    t.boolean  "is_memberlist_visible",             default: false, null: false
    t.boolean  "is_content_visible",                default: false, null: false
    t.boolean  "is_approval_required",              default: false, null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_types", ["created_by"], name: "index_group_types_on_created_by", using: :btree
  add_index "group_types", ["updated_by"], name: "index_group_types_on_updated_by", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",          limit: 200, default: "", null: false
    t.text     "description"
    t.integer  "group_type_id",                          null: false
    t.integer  "owner_user_id",             default: 0,  null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["created_by"], name: "index_groups_on_created_by", using: :btree
  add_index "groups", ["group_type_id"], name: "index_groups_on_group_type_id", using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree
  add_index "groups", ["owner_user_id"], name: "index_groups_on_owner_user_id", using: :btree
  add_index "groups", ["updated_by"], name: "index_groups_on_updated_by", using: :btree

  create_table "message_attachments", force: true do |t|
    t.integer  "message_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_attachments", ["created_by"], name: "index_message_attachments_on_created_by", using: :btree
  add_index "message_attachments", ["message_id"], name: "index_message_attachments_on_message_id", using: :btree
  add_index "message_attachments", ["updated_by"], name: "index_message_attachments_on_updated_by", using: :btree

  create_table "messages", force: true do |t|
    t.text     "body",                              null: false
    t.integer  "sender_user_id",                    null: false
    t.integer  "recipient_user_id",                 null: false
    t.datetime "viewed_date"
    t.boolean  "sender_deleted",    default: false, null: false
    t.boolean  "recipient_deleted", default: false, null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["created_by"], name: "index_messages_on_created_by", using: :btree
  add_index "messages", ["recipient_user_id"], name: "index_messages_on_recipient_user_id", using: :btree
  add_index "messages", ["sender_user_id"], name: "index_messages_on_sender_user_id", using: :btree
  add_index "messages", ["updated_by"], name: "index_messages_on_updated_by", using: :btree

  create_table "notifications", force: true do |t|
    t.boolean  "is_viewed",            default: false, null: false
    t.text     "body"
    t.integer  "notification_user_id"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "group_id"
    t.integer  "group_invite_id"
    t.integer  "post_id"
    t.integer  "user_connection_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["created_by"], name: "notifications_created_by_fk", using: :btree
  add_index "notifications", ["event_id"], name: "notifications_event_id_fk", using: :btree
  add_index "notifications", ["group_id"], name: "notifications_group_id_fk", using: :btree
  add_index "notifications", ["group_invite_id"], name: "notifications_group_invite_id_fk", using: :btree
  add_index "notifications", ["notification_user_id"], name: "notifications_notification_user_id_fk", using: :btree
  add_index "notifications", ["post_id"], name: "notifications_post_id_fk", using: :btree
  add_index "notifications", ["updated_by"], name: "notifications_updated_by_fk", using: :btree
  add_index "notifications", ["user_connection_id"], name: "notifications_user_connection_id_fk", using: :btree
  add_index "notifications", ["user_id"], name: "notifications_user_id_fk", using: :btree

  create_table "post_attachments", force: true do |t|
    t.integer  "post_id"
    t.string   "url"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_attachments", ["created_by"], name: "index_post_attachments_on_created_by", using: :btree
  add_index "post_attachments", ["post_id"], name: "index_post_attachments_on_post_id", using: :btree
  add_index "post_attachments", ["updated_by"], name: "index_post_attachments_on_updated_by", using: :btree

  create_table "post_comment_attachments", force: true do |t|
    t.integer  "post_comment_id"
    t.string   "url"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_comment_attachments", ["created_by"], name: "index_post_comment_attachments_on_created_by", using: :btree
  add_index "post_comment_attachments", ["post_comment_id"], name: "index_post_comment_attachments_on_post_comment_id", using: :btree
  add_index "post_comment_attachments", ["updated_by"], name: "index_post_comment_attachments_on_updated_by", using: :btree

  create_table "post_comments", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_comments", ["created_by"], name: "index_post_comments_on_created_by", using: :btree
  add_index "post_comments", ["post_id"], name: "index_post_comments_on_post_id", using: :btree
  add_index "post_comments", ["updated_by"], name: "index_post_comments_on_updated_by", using: :btree
  add_index "post_comments", ["user_id"], name: "index_post_comments_on_user_id", using: :btree

  create_table "post_contributors", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_contributors", ["created_by"], name: "index_article_contributors_on_created_by", using: :btree
  add_index "post_contributors", ["post_id"], name: "index_article_contributors_on_post_id", using: :btree
  add_index "post_contributors", ["updated_by"], name: "index_article_contributors_on_updated_by", using: :btree
  add_index "post_contributors", ["user_id"], name: "index_article_contributors_on_user_id", using: :btree

  create_table "post_followers", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_followers", ["created_by"], name: "index_post_followers_on_created_by", using: :btree
  add_index "post_followers", ["post_id"], name: "index_post_followers_on_post_id", using: :btree
  add_index "post_followers", ["updated_by"], name: "index_post_followers_on_updated_by", using: :btree
  add_index "post_followers", ["user_id"], name: "index_post_followers_on_user_id", using: :btree

  create_table "post_hides", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_hides", ["created_by"], name: "index_post_hides_on_created_by", using: :btree
  add_index "post_hides", ["post_id"], name: "index_post_hides_on_post_id", using: :btree
  add_index "post_hides", ["updated_by"], name: "index_post_hides_on_updated_by", using: :btree
  add_index "post_hides", ["user_id"], name: "index_post_hides_on_user_id", using: :btree

  create_table "post_likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_likes", ["created_by"], name: "index_post_likes_on_created_by", using: :btree
  add_index "post_likes", ["post_id"], name: "index_post_likes_on_post_id", using: :btree
  add_index "post_likes", ["updated_by"], name: "index_post_likes_on_updated_by", using: :btree
  add_index "post_likes", ["user_id"], name: "index_post_likes_on_user_id", using: :btree

  create_table "post_spam_reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "post_comment_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_spam_reports", ["created_by"], name: "index_post_spam_reports_on_created_by", using: :btree
  add_index "post_spam_reports", ["post_comment_id"], name: "index_post_spam_reports_on_post_comment_id", using: :btree
  add_index "post_spam_reports", ["post_id"], name: "index_post_spam_reports_on_post_id", using: :btree
  add_index "post_spam_reports", ["updated_by"], name: "index_post_spam_reports_on_updated_by", using: :btree
  add_index "post_spam_reports", ["user_id"], name: "index_post_spam_reports_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "body_markdown"
    t.text     "excerpt"
    t.string   "thumbnail_teaser_photo"
    t.integer  "display_rank"
    t.integer  "view_count"
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "event_session_id"
    t.integer  "sponsor_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["created_by"], name: "index_posts_on_created_by", using: :btree
  add_index "posts", ["event_id"], name: "posts_event_id_fk", using: :btree
  add_index "posts", ["event_session_id"], name: "posts_event_session_id_fk", using: :btree
  add_index "posts", ["group_id"], name: "index_posts_on_group_id", using: :btree
  add_index "posts", ["sponsor_id"], name: "index_posts_on_sponsor_id", using: :btree
  add_index "posts", ["updated_by"], name: "index_posts_on_updated_by", using: :btree

  create_table "sponsor_attachments", force: true do |t|
    t.integer  "sponsor_id"
    t.string   "url"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsor_attachments", ["created_by"], name: "index_sponsor_attachments_on_created_by", using: :btree
  add_index "sponsor_attachments", ["sponsor_id"], name: "index_sponsor_attachments_on_sponsor_id", using: :btree
  add_index "sponsor_attachments", ["updated_by"], name: "index_sponsor_attachments_on_updated_by", using: :btree

  create_table "sponsor_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "display_rank", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "sponsor_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsor_users", ["created_by"], name: "index_sponsor_users_on_created_by", using: :btree
  add_index "sponsor_users", ["sponsor_id", "user_id"], name: "unique_user_and_sponsor", unique: true, using: :btree
  add_index "sponsor_users", ["sponsor_id"], name: "index_sponsor_users_on_sponsor_id", using: :btree
  add_index "sponsor_users", ["updated_by"], name: "index_sponsor_users_on_updated_by", using: :btree
  add_index "sponsor_users", ["user_id"], name: "index_sponsor_users_on_user_id", using: :btree

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo"
    t.string   "url"
    t.integer  "event_id"
    t.integer  "group_id"
    t.integer  "sponsor_type_id",                 null: false
    t.boolean  "splash_sponsor",  default: false, null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsors", ["created_by"], name: "index_sponsors_on_created_by", using: :btree
  add_index "sponsors", ["event_id"], name: "index_sponsors_on_event_id", using: :btree
  add_index "sponsors", ["group_id"], name: "index_sponsors_on_group_id", using: :btree
  add_index "sponsors", ["sponsor_type_id"], name: "app_sponsors_sponsor_type_id_fk", using: :btree
  add_index "sponsors", ["updated_by"], name: "index_sponsors_on_updated_by", using: :btree

  create_table "timezones", force: true do |t|
    t.string   "name",       limit: 50
    t.integer  "offset"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timezones", ["created_by"], name: "index_timezones_on_created_by", using: :btree
  add_index "timezones", ["updated_by"], name: "index_timezones_on_updated_by", using: :btree

  create_table "user_connections", force: true do |t|
    t.boolean  "is_approved",       default: false, null: false
    t.integer  "sender_user_id",                    null: false
    t.integer  "recipient_user_id",                 null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_connections", ["created_by"], name: "index_connections_on_created_by", using: :btree
  add_index "user_connections", ["recipient_user_id"], name: "index_connections_on_recipient_user_id", using: :btree
  add_index "user_connections", ["sender_user_id", "recipient_user_id"], name: "index_connections_on_sender_user_id_and_recipient_user_id", unique: true, using: :btree
  add_index "user_connections", ["sender_user_id"], name: "index_connections_on_sender_user_id", using: :btree
  add_index "user_connections", ["updated_by"], name: "index_connections_on_updated_by", using: :btree

  create_table "user_hides", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "post_comment_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_hides", ["created_by"], name: "index_user_hides_on_created_by", using: :btree
  add_index "user_hides", ["post_comment_id"], name: "index_user_hides_on_post_comment_id", using: :btree
  add_index "user_hides", ["post_id"], name: "index_user_hides_on_post_id", using: :btree
  add_index "user_hides", ["updated_by"], name: "index_user_hides_on_updated_by", using: :btree
  add_index "user_hides", ["user_id"], name: "index_user_hides_on_user_id", using: :btree

  create_table "user_mentions", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "post_comment_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_mentions", ["created_by"], name: "index_user_mentions_on_created_by", using: :btree
  add_index "user_mentions", ["post_comment_id"], name: "index_user_mentions_on_post_comment_id", using: :btree
  add_index "user_mentions", ["post_id"], name: "index_user_mentions_on_post_id", using: :btree
  add_index "user_mentions", ["updated_by"], name: "index_user_mentions_on_updated_by", using: :btree
  add_index "user_mentions", ["user_id"], name: "index_user_mentions_on_user_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.string   "name",       limit: 30
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["created_by"], name: "index_user_roles_on_created_by", using: :btree
  add_index "user_roles", ["updated_by"], name: "index_user_roles_on_updated_by", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "authentication_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alt_email"
    t.string   "first_name",             limit: 100,              null: false
    t.string   "last_name",              limit: 100,              null: false
    t.string   "title"
    t.string   "organization_name"
    t.text     "bio"
    t.integer  "app_language_id"
    t.string   "photo"
    t.integer  "user_role_id"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "users", ["alt_email"], name: "index_users_on_alt_email", unique: true, using: :btree
  add_index "users", ["app_language_id"], name: "index_users_on_app_language_id", using: :btree
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["created_by"], name: "index_users_on_created_by", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["updated_by"], name: "index_users_on_updated_by", using: :btree
  add_index "users", ["user_role_id"], name: "index_users_on_user_role_id", using: :btree

  add_foreign_key "app_admin_users", "users", name: "app_admin_users_created_by_fk", column: "created_by"
  add_foreign_key "app_admin_users", "users", name: "app_admin_users_updated_by_fk", column: "updated_by"
  add_foreign_key "app_admin_users", "users", name: "app_admin_users_user_id_fk"

  add_foreign_key "app_label_dictionaries", "app_label_pages", name: "app_label_dictionaries_app_label_page_id_fk"
  add_foreign_key "app_label_dictionaries", "users", name: "app_label_dictionaries_created_by_fk", column: "created_by"
  add_foreign_key "app_label_dictionaries", "users", name: "app_label_dictionaries_updated_by_fk", column: "updated_by"

  add_foreign_key "app_labels", "app_label_dictionaries", name: "app_labels_app_label_dictionary_id_fk"
  add_foreign_key "app_labels", "events", name: "app_labels_event_id_fk"
  add_foreign_key "app_labels", "users", name: "app_labels_created_by_fk", column: "created_by"
  add_foreign_key "app_labels", "users", name: "app_labels_updated_by_fk", column: "updated_by"

  add_foreign_key "app_setting_dependencies", "app_setting_options", name: "app_setting_dependencies_app_setting_option_id_fk"
  add_foreign_key "app_setting_dependencies", "app_setting_options", name: "app_setting_dependencies_ibfk_1", column: "dependent_app_setting_option_id"

  add_foreign_key "app_setting_options", "app_setting_types", name: "app_setting_options_app_setting_type_id_fk"
  add_foreign_key "app_setting_options", "users", name: "app_setting_options_created_by_fk", column: "created_by"
  add_foreign_key "app_setting_options", "users", name: "app_setting_options_updated_by_fk", column: "updated_by"

  add_foreign_key "app_settings", "app_setting_options", name: "app_settings_app_setting_option_id_fk"
  add_foreign_key "app_settings", "events", name: "app_settings_event_id_fk"
  add_foreign_key "app_settings", "groups", name: "app_settings_group_id_fk"
  add_foreign_key "app_settings", "user_roles", name: "app_settings_user_role_id_fk"
  add_foreign_key "app_settings", "users", name: "app_settings_created_by_fk", column: "created_by"
  add_foreign_key "app_settings", "users", name: "app_settings_updated_by_fk", column: "updated_by"
  add_foreign_key "app_settings", "users", name: "app_settings_user_id_fk"

  add_foreign_key "app_supports", "users", name: "app_supports_created_by_fk", column: "created_by"
  add_foreign_key "app_supports", "users", name: "app_supports_updated_by_fk", column: "updated_by"

  add_foreign_key "banner_ads", "sponsors", name: "banner_ads_sponsor_id_fk"
  add_foreign_key "banner_ads", "users", name: "banner_ads_created_by_fk", column: "created_by"
  add_foreign_key "banner_ads", "users", name: "banner_ads_updated_by_fk", column: "updated_by"

  add_foreign_key "event_bookmarks", "event_sessions", name: "user_event_bookmarks_event_session_id_fk"
  add_foreign_key "event_bookmarks", "event_speakers", name: "user_event_bookmarks_event_speaker_id_fk"
  add_foreign_key "event_bookmarks", "event_users", name: "user_event_bookmarks_event_user_id_fk"
  add_foreign_key "event_bookmarks", "sponsors", name: "event_bookmarks_sponsor_id_fk"
  add_foreign_key "event_bookmarks", "users", name: "user_event_bookmarks_created_by_fk", column: "created_by"
  add_foreign_key "event_bookmarks", "users", name: "user_event_bookmarks_updated_by_fk", column: "updated_by"

  add_foreign_key "event_evaluations", "events", name: "event_evaluations_event_id_fk"
  add_foreign_key "event_evaluations", "user_roles", name: "event_evaluations_user_role_id_fk"
  add_foreign_key "event_evaluations", "users", name: "event_evaluations_created_by_fk", column: "created_by"
  add_foreign_key "event_evaluations", "users", name: "event_evaluations_updated_by_fk", column: "updated_by"

  add_foreign_key "event_followers", "events", name: "event_followers_event_id_fk"
  add_foreign_key "event_followers", "users", name: "event_followers_created_by_fk", column: "created_by"
  add_foreign_key "event_followers", "users", name: "event_followers_updated_by_fk", column: "updated_by"
  add_foreign_key "event_followers", "users", name: "event_followers_user_id_fk"

  add_foreign_key "event_leaderboards", "event_leaderboard_options", name: "event_leaderboards_event_leaderboard_option_id_fk"
  add_foreign_key "event_leaderboards", "users", name: "event_leaderboards_created_by_fk", column: "created_by"
  add_foreign_key "event_leaderboards", "users", name: "event_leaderboards_updated_by_fk", column: "updated_by"

  add_foreign_key "event_notes", "event_sessions", name: "user_event_notes_event_session_id_fk"
  add_foreign_key "event_notes", "event_speakers", name: "user_event_notes_event_speaker_id_fk"
  add_foreign_key "event_notes", "event_users", name: "user_event_notes_event_user_id_fk"
  add_foreign_key "event_notes", "sponsors", name: "event_notes_sponsor_id_fk"
  add_foreign_key "event_notes", "users", name: "user_event_notes_created_by_fk", column: "created_by"
  add_foreign_key "event_notes", "users", name: "user_event_notes_updated_by_fk", column: "updated_by"

  add_foreign_key "event_registration_statuses", "app_label_dictionaries", name: "event_registration_statuses_app_label_dictionary_id_fk"

  add_foreign_key "event_session_evaluations", "event_sessions", name: "event_session_evaluations_event_session_id_fk"
  add_foreign_key "event_session_evaluations", "users", name: "event_session_evaluations_created_by_fk", column: "created_by"
  add_foreign_key "event_session_evaluations", "users", name: "event_session_evaluations_updated_by_fk", column: "updated_by"

  add_foreign_key "event_sessions", "events", name: "event_sessions_event_id_fk"
  add_foreign_key "event_sessions", "groups", name: "event_sessions_breakout_group_id_fk", column: "breakout_group_id"
  add_foreign_key "event_sessions", "sponsors", name: "event_sessions_sponsor_id_fk"

  add_foreign_key "event_speakers", "event_sessions", name: "event_speakers_event_session_id_fk"
  add_foreign_key "event_speakers", "users", name: "event_speakers_created_by_fk", column: "created_by"
  add_foreign_key "event_speakers", "users", name: "event_speakers_updated_by_fk", column: "updated_by"
  add_foreign_key "event_speakers", "users", name: "event_speakers_user_id_fk"

  add_foreign_key "event_staff_users", "events", name: "event_staff_users_event_id_fk"
  add_foreign_key "event_staff_users", "users", name: "event_staff_users_created_by_fk", column: "created_by"
  add_foreign_key "event_staff_users", "users", name: "event_staff_users_updated_by_fk", column: "updated_by"
  add_foreign_key "event_staff_users", "users", name: "event_staff_users_user_id_fk"

  add_foreign_key "event_user_schedules", "event_sessions", name: "event_user_schedules_event_session_id_fk"
  add_foreign_key "event_user_schedules", "event_users", name: "event_user_schedules_event_user_id_fk"
  add_foreign_key "event_user_schedules", "users", name: "event_user_schedules_created_by_fk", column: "created_by"
  add_foreign_key "event_user_schedules", "users", name: "event_user_schedules_updated_by_fk", column: "updated_by"

  add_foreign_key "event_users", "event_registration_statuses", name: "event_users_event_registration_status_id_fk"
  add_foreign_key "event_users", "events", name: "event_users_event_id_fk"
  add_foreign_key "event_users", "sponsors", name: "event_users_sponsor_id_fk"
  add_foreign_key "event_users", "users", name: "event_users_created_by_fk", column: "created_by"
  add_foreign_key "event_users", "users", name: "event_users_updated_by_fk", column: "updated_by"
  add_foreign_key "event_users", "users", name: "event_users_user_id_fk"

  add_foreign_key "events", "countries", name: "events_country_id_fk"
  add_foreign_key "events", "groups", name: "events_group_id_fk"
  add_foreign_key "events", "timezones", name: "events_timezone_id_fk"
  add_foreign_key "events", "users", name: "events_created_by_fk", column: "created_by"
  add_foreign_key "events", "users", name: "events_updated_by_fk", column: "updated_by"

  add_foreign_key "featured_posts", "posts", name: "featured_posts_post_id_fk"
  add_foreign_key "featured_posts", "users", name: "featured_posts_created_by_fk", column: "created_by"
  add_foreign_key "featured_posts", "users", name: "featured_posts_updated_by_fk", column: "updated_by"

  add_foreign_key "group_invites", "groups", name: "group_invites_group_id_fk"
  add_foreign_key "group_invites", "users", name: "group_invites_user_id_fk"

  add_foreign_key "group_members", "groups", name: "group_members_group_id_fk"
  add_foreign_key "group_members", "users", name: "group_members_created_by_fk", column: "created_by"
  add_foreign_key "group_members", "users", name: "group_members_updated_by_fk", column: "updated_by"
  add_foreign_key "group_members", "users", name: "group_members_user_id_fk"

  add_foreign_key "group_requests", "groups", name: "group_requests_group_id_fk"
  add_foreign_key "group_requests", "users", name: "group_requests_created_by_fk", column: "created_by"
  add_foreign_key "group_requests", "users", name: "group_requests_updated_by_fk", column: "updated_by"
  add_foreign_key "group_requests", "users", name: "group_requests_user_id_fk"

  add_foreign_key "groups", "group_types", name: "groups_group_type_id_fk"
  add_foreign_key "groups", "users", name: "groups_created_by_fk", column: "created_by"
  add_foreign_key "groups", "users", name: "groups_owner_user_id_fk", column: "owner_user_id"
  add_foreign_key "groups", "users", name: "groups_updated_by_fk", column: "updated_by"

  add_foreign_key "message_attachments", "messages", name: "message_attachments_message_id_fk"
  add_foreign_key "message_attachments", "users", name: "message_attachments_created_by_fk", column: "created_by"
  add_foreign_key "message_attachments", "users", name: "message_attachments_updated_by_fk", column: "updated_by"

  add_foreign_key "messages", "users", name: "messages_created_by_fk", column: "created_by"
  add_foreign_key "messages", "users", name: "messages_recipient_user_id_fk", column: "recipient_user_id"
  add_foreign_key "messages", "users", name: "messages_sender_user_id_fk", column: "sender_user_id"
  add_foreign_key "messages", "users", name: "messages_updated_by_fk", column: "updated_by"

  add_foreign_key "notifications", "events", name: "notifications_event_id_fk"
  add_foreign_key "notifications", "group_invites", name: "notifications_group_invite_id_fk"
  add_foreign_key "notifications", "groups", name: "notifications_group_id_fk"
  add_foreign_key "notifications", "posts", name: "notifications_post_id_fk"
  add_foreign_key "notifications", "user_connections", name: "notifications_user_connection_id_fk"
  add_foreign_key "notifications", "users", name: "notifications_created_by_fk", column: "created_by"
  add_foreign_key "notifications", "users", name: "notifications_notification_user_id_fk", column: "notification_user_id"
  add_foreign_key "notifications", "users", name: "notifications_updated_by_fk", column: "updated_by"
  add_foreign_key "notifications", "users", name: "notifications_user_id_fk"

  add_foreign_key "post_attachments", "posts", name: "post_attachments_post_id_fk"
  add_foreign_key "post_attachments", "users", name: "post_attachments_created_by_fk", column: "created_by"
  add_foreign_key "post_attachments", "users", name: "post_attachments_updated_by_fk", column: "updated_by"

  add_foreign_key "post_comment_attachments", "post_comments", name: "post_comment_attachments_post_comment_id_fk"

  add_foreign_key "post_comments", "posts", name: "post_comments_post_id_fk"
  add_foreign_key "post_comments", "users", name: "post_comments_created_by_fk", column: "created_by"
  add_foreign_key "post_comments", "users", name: "post_comments_updated_by_fk", column: "updated_by"
  add_foreign_key "post_comments", "users", name: "post_comments_user_id_fk"

  add_foreign_key "post_contributors", "posts", name: "article_contributors_post_id_fk"
  add_foreign_key "post_contributors", "users", name: "article_contributors_created_by_fk", column: "created_by"
  add_foreign_key "post_contributors", "users", name: "article_contributors_updated_by_fk", column: "updated_by"
  add_foreign_key "post_contributors", "users", name: "article_contributors_user_id_fk"

  add_foreign_key "post_followers", "posts", name: "post_followers_post_id_fk"
  add_foreign_key "post_followers", "users", name: "post_followers_created_by_fk", column: "created_by"
  add_foreign_key "post_followers", "users", name: "post_followers_updated_by_fk", column: "updated_by"
  add_foreign_key "post_followers", "users", name: "post_followers_user_id_fk"

  add_foreign_key "post_hides", "posts", name: "post_hides_post_id_fk"
  add_foreign_key "post_hides", "users", name: "post_hides_created_by_fk", column: "created_by"
  add_foreign_key "post_hides", "users", name: "post_hides_updated_by_fk", column: "updated_by"
  add_foreign_key "post_hides", "users", name: "post_hides_user_id_fk"

  add_foreign_key "post_likes", "posts", name: "post_likes_post_id_fk"
  add_foreign_key "post_likes", "users", name: "post_likes_created_by_fk", column: "created_by"
  add_foreign_key "post_likes", "users", name: "post_likes_updated_by_fk", column: "updated_by"
  add_foreign_key "post_likes", "users", name: "post_likes_user_id_fk"

  add_foreign_key "post_spam_reports", "post_comments", name: "post_spam_reports_post_comment_id_fk"
  add_foreign_key "post_spam_reports", "posts", name: "post_spam_reports_post_id_fk"
  add_foreign_key "post_spam_reports", "users", name: "post_spam_reports_created_by_fk", column: "created_by"
  add_foreign_key "post_spam_reports", "users", name: "post_spam_reports_updated_by_fk", column: "updated_by"
  add_foreign_key "post_spam_reports", "users", name: "post_spam_reports_user_id_fk"

  add_foreign_key "posts", "event_sessions", name: "posts_event_session_id_fk"
  add_foreign_key "posts", "events", name: "posts_event_id_fk"
  add_foreign_key "posts", "groups", name: "posts_group_id_fk"
  add_foreign_key "posts", "sponsors", name: "posts_sponsor_id_fk"
  add_foreign_key "posts", "users", name: "posts_created_by_fk", column: "created_by"
  add_foreign_key "posts", "users", name: "posts_updated_by_fk", column: "updated_by"

  add_foreign_key "sponsor_attachments", "sponsors", name: "sponsor_attachments_sponsor_id_fk"
  add_foreign_key "sponsor_attachments", "users", name: "sponsor_attachments_created_by_fk", column: "created_by"
  add_foreign_key "sponsor_attachments", "users", name: "sponsor_attachments_updated_by_fk", column: "updated_by"

  add_foreign_key "sponsor_users", "sponsors", name: "sponsor_users_sponsor_id_fk"
  add_foreign_key "sponsor_users", "users", name: "sponsor_users_created_by_fk", column: "created_by"
  add_foreign_key "sponsor_users", "users", name: "sponsor_users_updated_by_fk", column: "updated_by"
  add_foreign_key "sponsor_users", "users", name: "sponsor_users_user_id_fk"

  add_foreign_key "sponsors", "sponsor_types", name: "app_sponsors_sponsor_type_id_fk"

  add_foreign_key "user_connections", "users", name: "connections_created_by_fk", column: "created_by"
  add_foreign_key "user_connections", "users", name: "connections_recipient_user_id_fk", column: "recipient_user_id"
  add_foreign_key "user_connections", "users", name: "connections_sender_user_id_fk", column: "sender_user_id"
  add_foreign_key "user_connections", "users", name: "connections_updated_by_fk", column: "updated_by"

  add_foreign_key "user_hides", "post_comments", name: "user_hides_post_comment_id_fk"
  add_foreign_key "user_hides", "posts", name: "user_hides_post_id_fk"
  add_foreign_key "user_hides", "users", name: "user_hides_created_by_fk", column: "created_by"
  add_foreign_key "user_hides", "users", name: "user_hides_updated_by_fk", column: "updated_by"
  add_foreign_key "user_hides", "users", name: "user_hides_user_id_fk"

  add_foreign_key "user_mentions", "post_comments", name: "user_mentions_post_comment_id_fk"
  add_foreign_key "user_mentions", "posts", name: "user_mentions_post_id_fk"
  add_foreign_key "user_mentions", "users", name: "user_mentions_created_by_fk", column: "created_by"
  add_foreign_key "user_mentions", "users", name: "user_mentions_updated_by_fk", column: "updated_by"
  add_foreign_key "user_mentions", "users", name: "user_mentions_user_id_fk"

  add_foreign_key "user_roles", "users", name: "user_roles_created_by_fk", column: "created_by"
  add_foreign_key "user_roles", "users", name: "user_roles_updated_by_fk", column: "updated_by"

  add_foreign_key "users", "user_roles", name: "users_user_role_id_fk"
  add_foreign_key "users", "users", name: "users_created_by_fk", column: "created_by"
  add_foreign_key "users", "users", name: "users_updated_by_fk", column: "updated_by"

end
