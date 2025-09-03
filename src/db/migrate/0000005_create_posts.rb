class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :account, null: true, foreign_key: true
      t.string :aid, null: false, limit: 14
      t.string :title, null: false
      t.text :summary, null: false
      t.text :content, null: false
      t.text :content_cache, null: false, default: ""
      t.datetime :published_at, null: true
      t.datetime :edited_at, null: true
      t.json :meta, null: false, default: {}
      t.integer :status, null: false, limit: 1, default: 0

      t.timestamps
    end
    add_index :posts, :aid, unique: true
  end
end
