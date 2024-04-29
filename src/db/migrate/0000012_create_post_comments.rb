class CreatePostComments < ActiveRecord::Migration[7.1]
  def change
    create_table :post_comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
