class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :aid, null: false
      t.string :name_id, null: false
      t.string :icon_original_key, null: false, default: ''
      t.json :icon_variants, null: false, default: []
      t.string :name, null: false
      t.text :description, null: false, default: ''
      t.boolean :public, null: false, default: false
      t.bigint :views_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.json :settings, null: false, default: []
      t.json :metadata, null: false, default: []
      t.json :roles, null: false, default: []
      t.string :password_digest, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :accounts, [:aid, :name_id], unique: true
  end
end
