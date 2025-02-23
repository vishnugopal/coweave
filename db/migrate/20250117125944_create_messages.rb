class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :playthrough, null: false, foreign_key: true
      t.integer :role, null: false, default: 0
      t.string :content, null: false
      t.integer :response_number, null: false, default: 0

      t.timestamps
    end
  end
end
