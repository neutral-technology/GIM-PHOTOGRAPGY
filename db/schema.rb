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

ActiveRecord::Schema[7.0].define(version: 2026_06_22_134542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "slug"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.boolean "public"
    t.string "access_code"
    t.index ["client_id"], name: "index_albums_on_client_id"
    t.index ["slug"], name: "index_albums_on_slug", unique: true
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "brochure_blocks", force: :cascade do |t|
    t.bigint "brochure_page_id", null: false
    t.string "block_type"
    t.text "content"
    t.integer "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["brochure_page_id", "position"], name: "index_brochure_blocks_on_brochure_page_id_and_position"
    t.index ["brochure_page_id"], name: "index_brochure_blocks_on_brochure_page_id"
  end

  create_table "brochure_pages", force: :cascade do |t|
    t.bigint "brochure_id", null: false
    t.integer "position"
    t.string "layout"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brochure_id"], name: "index_brochure_pages_on_brochure_id"
  end

  create_table "brochure_presets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "theme"
  end

  create_table "brochures", force: :cascade do |t|
    t.string "title"
    t.string "ceremony_type"
    t.string "status"
    t.bigint "client_id", null: false
    t.bigint "user_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brochure_preset_id"
    t.jsonb "theme_overrides"
    t.string "custom_cover_layout"
    t.boolean "watermark_enabled", default: true, null: false
    t.string "kind"
    t.index ["brochure_preset_id"], name: "index_brochures_on_brochure_preset_id"
    t.index ["client_id"], name: "index_brochures_on_client_id"
    t.index ["user_id"], name: "index_brochures_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tel"
    t.integer "fidelity_points"
    t.string "fidelity_level"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.integer "currency"
    t.integer "category"
    t.string "note"
    t.integer "status", default: 0, null: false
    t.date "expense_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "status_changed_at"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "downloaded_at"
    t.index ["album_id"], name: "index_images_on_album_id"
  end

  create_table "invitation_guests", force: :cascade do |t|
    t.bigint "brochure_id", null: false
    t.string "name"
    t.string "phone"
    t.string "table"
    t.string "token"
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "accepted_at"
    t.boolean "checked_in", default: false
    t.datetime "checked_in_at"
    t.datetime "sent_at"
    t.index ["brochure_id"], name: "index_invitation_guests_on_brochure_id"
  end

  create_table "photographers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
  end

  create_table "receipts", force: :cascade do |t|
    t.integer "shooting_type"
    t.integer "photos_count"
    t.decimal "amount"
    t.date "date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.bigint "album_id", null: false
    t.integer "currency"
    t.decimal "amount_paid"
    t.decimal "balance"
    t.decimal "exchange_rate", precision: 15, scale: 4, default: "1.0"
    t.integer "paid_currency", default: 0
    t.string "serial_code", null: false
    t.integer "fidelity_points"
    t.bigint "photographer_id"
    t.bigint "created_by_id", null: false
    t.index ["album_id"], name: "index_receipts_on_album_id"
    t.index ["client_id"], name: "index_receipts_on_client_id"
    t.index ["created_by_id"], name: "index_receipts_on_created_by_id"
    t.index ["photographer_id"], name: "index_receipts_on_photographer_id"
    t.index ["serial_code"], name: "index_receipts_on_serial_code", unique: true
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "tarifs", force: :cascade do |t|
    t.integer "service"
    t.decimal "price"
    t.string "note"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "currency"
    t.index ["user_id", "service"], name: "index_tarifs_on_user_id_and_service", unique: true
    t.index ["user_id"], name: "index_tarifs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "city"
    t.string "sex"
    t.string "tel"
    t.string "unique_id"
    t.integer "vip_threshold"
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unique_id"], name: "index_users_on_unique_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "clients"
  add_foreign_key "albums", "users"
  add_foreign_key "brochure_blocks", "brochure_pages"
  add_foreign_key "brochure_pages", "brochures"
  add_foreign_key "brochures", "brochure_presets"
  add_foreign_key "brochures", "clients"
  add_foreign_key "brochures", "users"
  add_foreign_key "clients", "users"
  add_foreign_key "expenses", "users"
  add_foreign_key "images", "albums"
  add_foreign_key "invitation_guests", "brochures"
  add_foreign_key "receipts", "albums"
  add_foreign_key "receipts", "clients"
  add_foreign_key "receipts", "photographers"
  add_foreign_key "receipts", "photographers", column: "created_by_id"
  add_foreign_key "receipts", "users"
  add_foreign_key "tarifs", "users"
end
