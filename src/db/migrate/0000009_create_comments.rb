class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :account, null: true, foreign_key: true
      t.string :comment_id, null: false, default: ''
      t.string :name, null: false, default: ''
      t.text :content, null: false, default: ''
      t.string :contact, null: false, default: ''
      t.boolean :public_visibility, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
