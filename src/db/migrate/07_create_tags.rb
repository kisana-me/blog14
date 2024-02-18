class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false, default: ''
      t.string :tag_name_id, null: false
      t.string :description, null: false, default: ''
      t.integer :posts_count, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :tags, [:tag_name_id], unique: true
  end
end
