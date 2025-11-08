class AllExporter
  def call
    export_accounts
    export_tags
    export_posts
    export_images
  end

  private

  def export_accounts
    dir = Rails.root.join('storage', 'accounts')
    FileUtils.mkdir_p(dir)
    accounts_data = Account.order(:created_at).map(&:aid)
    File.write(dir.join('accounts.json'), JSON.pretty_generate(accounts_data))

    Account.find_each do |account|
      AccountExporter.new(account).call
    end
  end

  def export_tags
    TagsExporter.new.call
  end

  def export_posts
    dir = Rails.root.join('storage', 'posts')
    FileUtils.mkdir_p(dir)
    posts_data = Post.order(:created_at).map(&:aid)
    File.write(dir.join('posts.json'), JSON.pretty_generate(posts_data))

    Post.find_each do |post|
      PostExporter.new(post).call
    end
  end

  def export_images
    ImagesExporter.new.call
  end
end
