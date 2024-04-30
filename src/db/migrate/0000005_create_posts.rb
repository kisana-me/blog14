class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :image, null: true, foreign_key: true
      t.string :aid, null: false
      t.string :title, null: false, default: ''
      t.text :summary, null: false, default: ''
      t.text :content, null: false, default: ''
      t.boolean :draft, null: false, default: false
      t.integer :comments_count, null: false, default: 0
      t.bigint :views_count, null: false, default: 0
      t.json :metadata, null: false, default: []
      t.datetime :published_at, null: false
      t.datetime :edited_at, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :posts, [:aid], unique: true
  end
end
