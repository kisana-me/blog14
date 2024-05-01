class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true
      t.references :comment, null: true, foreign_key: { to_table: :comments }
      t.string :aid, null: false, default: ''
      t.string :name, null: false, default: ''
      t.text :content, null: false, default: ''
      t.string :address, null: false, default: ''
      t.boolean :public, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :comments, [:aid], unique: true
  end
end
