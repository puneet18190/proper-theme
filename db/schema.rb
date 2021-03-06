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

ActiveRecord::Schema.define(version: 20160922143731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
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

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "advertisements", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "email"
    t.string   "phone"
    t.string   "image"
    t.date     "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_id"
    t.string   "fb_id"
    t.string   "twitter_id"
  end

  create_table "appraisals", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "contact"
    t.string   "status"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.string   "attached_file_file_name"
    t.string   "attached_file_content_type"
    t.integer  "attached_file_file_size"
    t.datetime "attached_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_id"
  end

  create_table "blms", force: true do |t|
    t.string   "name"
    t.datetime "upload_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",       default: 0
  end

  create_table "contact_agents", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_id"
    t.string   "page_link"
  end

  create_table "contact_notes", force: true do |t|
    t.string   "notes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_notes", ["user_id"], name: "index_contact_notes_on_user_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_id"
    t.string   "contact_number"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "directory_entries", force: true do |t|
    t.string   "Name"
    t.string   "Telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "guarantors", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "previous_name"
    t.string   "dob"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "postcode"
    t.string   "home_tel"
    t.string   "mobile_tel"
    t.string   "email"
    t.string   "emp_status"
    t.string   "emp_from"
    t.string   "job_title"
    t.string   "annual_inc"
    t.string   "ref_name"
    t.string   "ref_job"
    t.string   "ref_company"
    t.string   "ref_address"
    t.string   "ref_tel"
    t.string   "ref_email"
    t.string   "ref_rel"
    t.string   "outcome"
    t.text     "add_info"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "key_books", force: true do |t|
    t.integer  "property_id"
    t.integer  "key_id"
    t.string   "name"
    t.string   "status"
    t.datetime "book_time"
    t.string   "person"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keys", force: true do |t|
    t.integer  "key_number"
    t.string   "key_status",  default: "unassign"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_merge_items", force: true do |t|
    t.string   "filename"
    t.string   "url"
    t.string   "m_type"
    t.integer  "mail_merge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_url"
  end

  create_table "mail_merges", force: true do |t|
    t.string   "filename"
    t.string   "url"
    t.string   "m_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "messages", force: true do |t|
    t.text     "subject"
    t.string   "to"
    t.string   "from"
    t.text     "html_body"
    t.text     "text_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "date"
  end

  create_table "miscellaneous_contacts", force: true do |t|
    t.string   "first_name"
    t.string   "company"
    t.string   "category"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "position"
    t.string   "mobile"
    t.string   "web"
    t.text     "notes"
    t.string   "avatar"
  end

  create_table "mobiles", force: true do |t|
    t.string   "name"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pet_details", force: true do |t|
    t.string   "pet_name"
    t.string   "pet_type"
    t.string   "pet_breed"
    t.string   "pet_age"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.string   "callerid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "call_action"
    t.string   "dataname"
    t.string   "local"
    t.string   "remote"
    t.string   "display_local"
    t.string   "display_remote"
  end

  create_table "properties", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.decimal  "amount"
    t.integer  "bath"
    t.integer  "beds"
    t.boolean  "parking"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.string   "image5"
    t.string   "image6"
    t.text     "description"
    t.date     "date"
    t.boolean  "visibility"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.decimal  "price"
    t.string   "name"
    t.string   "postcode"
    t.boolean  "sold"
    t.boolean  "let"
    t.boolean  "featured"
    t.date     "s_date"
    t.date     "l_date"
    t.date     "r_date"
    t.integer  "user_id"
    t.boolean  "approve",              default: false
    t.boolean  "payment",              default: false
    t.string   "slug"
    t.datetime "validity"
    t.string   "coordinates"
    t.integer  "agent_id"
    t.string   "image7"
    t.string   "image8"
    t.string   "image9"
    t.string   "image10"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "radius"
    t.string   "approval_status",      default: "false"
    t.text     "short_description"
    t.string   "gas_ch",               default: "No"
    t.boolean  "glazing",              default: false
    t.string   "parking_status",       default: "none"
    t.integer  "car"
    t.text     "tag_line"
    t.string   "garden",               default: "No"
    t.string   "dg",                   default: false
    t.boolean  "seal_approved",        default: false
    t.string   "pets",                 default: "No"
    t.string   "ensuite",              default: "No"
    t.string   "town"
    t.string   "status"
    t.string   "postcode1"
    t.string   "qualifier"
    t.text     "summary"
    t.string   "furnished"
    t.string   "feature1"
    t.string   "feature2"
    t.integer  "property_type"
    t.string   "let_type_id",          default: "Not Specified"
    t.string   "let_furn_id",          default: "Not Specified"
    t.string   "epc"
    t.string   "brochure_link"
    t.datetime "let_date_available"
    t.boolean  "otm",                  default: true
    t.boolean  "accredited"
    t.boolean  "licensed"
    t.string   "tenant_criteria"
    t.string   "cp12"
    t.string   "esc"
    t.string   "bond"
    t.text     "deal"
    t.string   "stage"
    t.boolean  "managed"
    t.boolean  "board"
    t.datetime "let_agreed_date"
    t.datetime "sold_date"
    t.string   "property_create_user"
    t.text     "marketing_notes"
    t.date     "epc_date_complete"
    t.date     "epc_due_date"
    t.date     "cp12_date_complete"
    t.date     "cp12_due_date"
    t.date     "esc_date_complete"
    t.date     "esc_due_date"
    t.integer  "tenant_id"
    t.boolean  "mouse_price",          default: true
    t.boolean  "dss_move",             default: true
    t.boolean  "home",                 default: true
    t.boolean  "wonder_property",      default: true
    t.datetime "key_assign_date"
    t.datetime "key_unassign_date"
    t.boolean  "zoopla",               default: true
    t.boolean  "nethouse",             default: true
    t.integer  "let_rent_frequency",   default: 1
    t.boolean  "portal_visibility",    default: true
  end

  add_index "properties", ["slug"], name: "index_properties_on_slug", unique: true, using: :btree

  create_table "property_changes", force: true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "postcode"
    t.string   "postcode1"
    t.integer  "property_type"
    t.integer  "beds"
    t.integer  "bath"
    t.string   "parking_status",    default: "none"
    t.integer  "car"
    t.string   "ensuite",           default: "No"
    t.string   "let_type_id",       default: "Not Specified"
    t.string   "let_furn_id",       default: "Not Specified"
    t.string   "gas_ch",            default: "No"
    t.string   "garden",            default: "No"
    t.string   "dg"
    t.string   "pets",              default: "No"
    t.string   "feature1"
    t.string   "feature2"
    t.string   "category"
    t.string   "status"
    t.decimal  "price"
    t.text     "tag_line"
    t.text     "summary"
    t.text     "short_description"
    t.text     "description"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "town"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.string   "image5"
    t.string   "image6"
    t.string   "image7"
    t.string   "image8"
    t.string   "image9"
    t.string   "image10"
    t.string   "epc"
  end

  add_index "property_changes", ["property_id"], name: "index_property_changes_on_property_id", using: :btree

  create_table "property_documents", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.date     "date_completed"
    t.date     "due_date"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "property_documents", ["property_id"], name: "index_property_documents_on_property_id", using: :btree

  create_table "property_infos", force: true do |t|
    t.integer  "battery"
    t.string   "battery_operated"
    t.integer  "mains"
    t.string   "mains_operated"
    t.integer  "carbon"
    t.string   "carbon_monoxide"
    t.string   "elec_meter_loc"
    t.string   "elec_last_supplier"
    t.string   "gas_meter_loc"
    t.string   "gas_last_supplier"
    t.string   "gas_valve"
    t.string   "water_meter_loc"
    t.string   "water_stopcock_loc"
    t.string   "bin_coll_day"
    t.string   "alarm_loc"
    t.string   "alarm_code"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_types", force: true do |t|
    t.string   "p_type"
    t.string   "search"
    t.integer  "p_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provisions", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "right_to_rents", force: true do |t|
    t.date     "date_check"
    t.date     "expiry_doc"
    t.boolean  "doc_recheck"
    t.date     "recheck_due"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "screens", force: true do |t|
    t.string   "name"
    t.boolean  "status",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "admin_image"
    t.string   "admin_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "property_description"
    t.string   "screen_text"
    t.boolean  "newest_screen"
    t.text     "newest_screen_text"
    t.boolean  "oldest_screen"
    t.text     "oldest_screen_text"
    t.boolean  "featured_screen"
    t.text     "featured_screen_text"
    t.boolean  "cycle_screen"
    t.text     "cycle_screen_text"
    t.boolean  "random_screen"
    t.text     "random_screen_text"
    t.text     "newest_inside_text"
    t.boolean  "newest_inside"
    t.text     "oldest_inside_text"
    t.boolean  "oldest_inside"
    t.text     "featured_inside_text"
    t.boolean  "featured_inside"
    t.text     "cycle_inside_text"
    t.boolean  "cycle_inside"
    t.text     "random_inside_text"
    t.boolean  "random_inside"
    t.string   "sms_destination_no"
    t.boolean  "send_sms_on_signup",   default: false
    t.boolean  "send_sms_on_msg",      default: false
  end

  create_table "sms", force: true do |t|
    t.string   "originator"
    t.string   "destination"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tenancy_terms", force: true do |t|
    t.date     "start_date"
    t.string   "tenancy_length"
    t.string   "agreed_rent"
    t.string   "agreed_bond"
    t.string   "advanced_payment"
    t.boolean  "shared"
    t.boolean  "garden"
    t.boolean  "parking"
    t.boolean  "other"
    t.boolean  "water"
    t.boolean  "council_tax"
    t.boolean  "gas"
    t.boolean  "electricity"
    t.boolean  "tv_licence"
    t.boolean  "telephone"
    t.boolean  "broadband"
    t.boolean  "inventory"
    t.boolean  "guarantor_agreement"
    t.boolean  "epc"
    t.boolean  "rent_guide"
    t.boolean  "smoke_alarm"
    t.boolean  "pet"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tenant_histroys", force: true do |t|
    t.string   "name"
    t.date     "tenancy_start_date"
    t.date     "tenancy_end_date"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tenant_properties", force: true do |t|
    t.integer  "property_id"
    t.integer  "tenant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "testimonial"
    t.date     "t_date"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "address"
    t.string   "phone"
    t.string   "status"
    t.boolean  "payment",                default: false
    t.string   "search"
    t.string   "fb_token"
    t.string   "plan",                   default: "free"
    t.datetime "validity"
    t.string   "title"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "postcode"
    t.string   "mobile"
    t.string   "employment"
    t.integer  "price"
    t.string   "deposit"
    t.integer  "tenancy"
    t.string   "student"
    t.string   "benefit"
    t.string   "pets"
    t.string   "smoker"
    t.string   "property_type"
    t.integer  "beds"
    t.integer  "bath"
    t.integer  "max_price"
    t.string   "furnished"
    t.string   "garden"
    t.string   "ensuite"
    t.string   "parking"
    t.string   "gas_ch"
    t.string   "dg"
    t.string   "tenancy_type"
    t.date     "dob"
    t.string   "last_name"
    t.string   "avatar"
    t.text     "additional_info"
    t.string   "supporting_doc"
    t.string   "tenant_status"
    t.text     "notes"
    t.integer  "tenant_property_id"
    t.boolean  "po",                     default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vettings", force: true do |t|
    t.string   "vetting_type"
    t.date     "submission_date"
    t.date     "outcome_date"
    t.string   "outcome"
    t.boolean  "guarantor"
    t.string   "vetting_doc"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yealink_phones", force: true do |t|
    t.string   "name"
    t.string   "callerid"
    t.string   "department"
    t.string   "status"
    t.integer  "call_duration"
    t.string   "callid"
    t.string   "mac"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "callaction"
  end

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
