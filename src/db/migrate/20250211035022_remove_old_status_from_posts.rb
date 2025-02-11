class RemoveOldStatusFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :unlisted, :boolean
    remove_column :posts, :public, :boolean
  end
end
