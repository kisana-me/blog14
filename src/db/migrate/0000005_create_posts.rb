class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :account, null: true, foreign_key: true
      t.string :aid, null: false, limit: 14
      t.string :name_id, null: false
      t.references :thumbnail, null: true, foreign_key: { to_table: :images }
      t.string :title, null: false, default: ""
      t.text :summary, null: false, default: ""
      t.text :content, null: false, default: ""
      t.datetime :published_at, null: true
      t.datetime :edited_at, null: true
      t.integer :visibility, null: false, limit: 1, default: 0
      t.json :meta, null: false, default: {}
      t.integer :status, null: false, limit: 1, default: 0

      t.timestamps
    end
    add_index :posts, :aid, unique: true
    add_index :posts, :name_id, unique: true
  end
end
