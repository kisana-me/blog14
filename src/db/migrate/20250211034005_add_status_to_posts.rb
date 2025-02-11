class AddStatusToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :status, :integer, limit: 1, default: 0, null: false
  end
end
