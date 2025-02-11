class MigratePostStatus < ActiveRecord::Migration[7.1]
  def up
    Post.reset_column_information
    Post.find_each do |post|
      if post.public
        post.update_columns(status: 2)
      elsif post.unlisted
        post.update_columns(status: 1)
      else
        post.update_columns(status: 0)
      end
    end
  end

  def down
    Post.find_each do |post|
      post.update_columns(
        public: post.status == 2,
        unlisted: post.status == 1
      )
    end
  end
end
