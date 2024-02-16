class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ''
      t.string :image_name_id, null: false
      t.boolean :nsfw, null: false, default: false
      t.string :nsfw_message, null: false, default: ''
      t.boolean :public_visibility, null: false, default: true
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :images, [:image_name_id], unique: true
  end
end
