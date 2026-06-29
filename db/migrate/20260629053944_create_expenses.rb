class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.string :category
      t.string :description
      t.date :expense_date
      t.boolean :ai_categorized

      t.timestamps
    end
  end
end
