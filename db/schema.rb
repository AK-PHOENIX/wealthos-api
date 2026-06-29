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

ActiveRecord::Schema[8.1].define(version: 2026_06_29_053945) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.string "condition"
    t.datetime "created_at", null: false
    t.datetime "notified_at"
    t.string "symbol"
    t.decimal "target_price"
    t.boolean "triggered"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "budget_goals", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.integer "month"
    t.decimal "monthly_limit"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "year"
    t.index ["user_id"], name: "index_budget_goals_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.boolean "ai_categorized"
    t.decimal "amount"
    t.string "category"
    t.datetime "created_at", null: false
    t.string "description"
    t.date "expense_date"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "holdings", force: :cascade do |t|
    t.string "asset_type"
    t.date "buy_date"
    t.decimal "buy_price"
    t.datetime "created_at", null: false
    t.bigint "portfolio_id", null: false
    t.decimal "quantity"
    t.string "symbol"
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_holdings_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "holding_id", null: false
    t.decimal "price"
    t.decimal "quantity"
    t.date "transaction_date"
    t.string "transaction_type"
    t.datetime "updated_at", null: false
    t.index ["holding_id"], name: "index_transactions_on_holding_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "email"
    t.decimal "monthly_income"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alerts", "users"
  add_foreign_key "budget_goals", "users"
  add_foreign_key "expenses", "users"
  add_foreign_key "holdings", "portfolios"
  add_foreign_key "portfolios", "users"
  add_foreign_key "transactions", "holdings"
end
