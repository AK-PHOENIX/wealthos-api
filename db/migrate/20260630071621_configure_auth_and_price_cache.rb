class ConfigureAuthAndPriceCache < ActiveRecord::Migration[8.1]
  def change
    # 1. Add Devise columns to users
    change_table :users do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    add_index :users, :reset_password_token, unique: true

    # 2. Create jwt_denylist table
    create_table :jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
      t.timestamps
    end
    add_index :jwt_denylist, :jti, unique: true

    # 3. Create price_caches table
    create_table :price_caches do |t|
      t.string :symbol, null: false
      t.string :asset_type, null: false
      t.decimal :price, precision: 15, scale: 4, null: false
      t.timestamps
    end
    add_index :price_caches, [:symbol, :asset_type], unique: true
  end
end
