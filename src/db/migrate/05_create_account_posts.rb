class CreateAccountPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :account_posts do |t|
      t.references :account, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.string :role, null: false, default: ''
      t.boolean :manager, null: false, default: true

      t.timestamps
    end
  end
end
