class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :aid, null: false, limit: 14
      t.string :name, null: false
      t.string :name_id, null: false
      t.text :description, null: false, default: ""
      t.text :description_cache, null: false, default: ""
      t.json :meta, null: false, default: {}
      t.integer :status, null: false, limit: 1, default: 0

      t.timestamps
    end
    add_index :tags, :aid, unique: true
  end
end
