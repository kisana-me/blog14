class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :session_id, null: false
      t.string :name, null: false, default: ''
      t.string :session_digest, null: false

      t.timestamps
    end
    add_index :sessions, [:session_id], unique: true
  end
end
