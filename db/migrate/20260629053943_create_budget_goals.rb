class CreateBudgetGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :budget_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :category
      t.decimal :monthly_limit
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
