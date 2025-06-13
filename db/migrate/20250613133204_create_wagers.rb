class CreateWagers < ActiveRecord::Migration[7.1]
  def change
    create_table :wagers do |t|
      t.date :date, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :odds, null: false
      t.string :result, null: false
      t.string :sportsbook, null: false
      t.text :tags
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end