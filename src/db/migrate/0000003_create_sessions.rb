class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.string :session_digest, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :sessions, [:aid], unique: true
  end
end
