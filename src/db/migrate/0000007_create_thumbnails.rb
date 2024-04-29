class CreateThumbnails < ActiveRecord::Migration[7.1]
  def change
    create_table :thumbnails do |t|
      t.references :post, null: false, foreign_key: true
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
  end
end
