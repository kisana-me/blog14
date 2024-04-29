class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.boolean :public_visibility, null: false, default: true
      t.string :original_key, null: false, default: ''
      t.json :variants, null: false, default: []
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :images, [:aid], unique: true
  end
end
