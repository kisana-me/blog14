class CreateAccountPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :account_posts do |t|
      t.references :account, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :administrator, null: false, default: true

      t.timestamps
    end
  end
end
