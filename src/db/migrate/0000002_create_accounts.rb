class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :anyur_id, null: true
      t.string :anyur_access_token, null: true
      t.string :anyur_refresh_token, null: true
      t.datetime :anyur_token_fetched_at, null: true
      t.string :aid, null: false, limit: 14
      t.string :name, null: false
      t.string :name_id, null: false
      t.bigint :icon_id, null: true
      t.text :description, null: false, default: ""
      t.integer :visibility, limit: 1, null: false, default: 0
      t.string :password_digest, null: false, default: ""
      t.json :meta, null: false, default: {}
      t.integer :status, limit: 1, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :accounts, :anyur_id, unique: true
    add_index :accounts, :aid, unique: true
    add_index :accounts, :name_id, unique: true
  end
end
