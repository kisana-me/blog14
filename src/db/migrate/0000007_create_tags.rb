class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.boolean :public, null: false, default: false
      t.integer :posts_count, null: false, default: 0
      t.bigint :views_count, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :tags, [:aid], unique: true
  end
end
