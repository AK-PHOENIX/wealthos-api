class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :holding, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :quantity
      t.decimal :price
      t.date :transaction_date

      t.timestamps
    end
  end
end
