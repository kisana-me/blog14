class CreateOthers < ActiveRecord::Migration[7.1]
  def change
    create_table :others do |t|
      t.string :aid, null: false, default: ''
      t.string :others_type, null: false, default: ''
      t.text :content, null: false, default: ''
      t.text :memo, null: false, default: ''
      t.json :metadata, null: false, default: []
      t.boolean :done, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :others, [:aid], unique: true
  end
end
