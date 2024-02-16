class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :account, null: false, foreign_key: true
      t.string :post_name_id, null: false
      t.string :thumbnail, null: false, default: ''
      t.string :title, null: false, default: ''
      t.text :summary, null: false, default: ''
      t.text :content, null: false, default: ''
      t.boolean :draft, null: false, default: false
      t.json :metadata, null: false, default: []
      t.integer :comments_count, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :posts, [:post_name_id], unique: true
  end
end
