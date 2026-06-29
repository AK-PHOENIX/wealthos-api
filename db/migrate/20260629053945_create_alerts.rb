class CreateAlerts < ActiveRecord::Migration[8.1]
  def change
    create_table :alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol
      t.string :condition
      t.decimal :target_price
      t.boolean :triggered
      t.datetime :notified_at

      t.timestamps
    end
  end
end
