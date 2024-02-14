class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :account, null: false, foreign_key: true
      t.string :post_id, null: false
      t.string :title, null: false, default: ''
      t.text :content, null: false, default: ''
      t.boolean :draft, null: false, default: false
      t.json :metadata, null: false, default: []

      t.timestamps
    end
    add_index :posts, [:post_id], unique: true
  end
end
