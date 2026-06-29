class CreateHoldings < ActiveRecord::Migration[8.1]
  def change
    create_table :holdings do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.string :symbol
      t.string :asset_type
      t.decimal :quantity
      t.decimal :buy_price
      t.date :buy_date

      t.timestamps
    end
  end
end
