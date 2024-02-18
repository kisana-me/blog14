class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :account_id, null: false
      t.string :name, null: false
      t.string :name_id, null: false
      t.string :icon, null: false, default: ''
      t.text :bio, null: false, default: ''
      t.integer :posts_count, null: false, default: 0
      t.json :settings, null: false, default: []
      t.json :metadata, null: false, default: []
      t.string :role, null: false, default: ''
      t.string :password_digest, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :accounts, [:account_id, :name_id], unique: true
  end
end
