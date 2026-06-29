class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.decimal :monthly_income
      t.string :currency

      t.timestamps
    end
  end
end
