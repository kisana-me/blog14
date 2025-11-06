class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true
      t.references :comment, null: true, foreign_key: { to_table: :comments }
      t.string :aid, null: false, limit: 14
      t.string :name, null: false
      t.text :content, null: false
      t.string :address, null: false, default: ""
      t.integer :visibility, null: false, limit: 1, default: 0
      t.json :meta, null: false, default: {}
      t.integer :status, null: false, limit: 1, default: 0

      t.timestamps
    end
    add_index :comments, :aid, unique: true
  end
end
