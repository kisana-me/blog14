class AllExporter
  def call
    export_accounts
    export_tags
    export_posts
    export_images
  end

  private

  def export_accounts
    Account.find_each do |account|
      AccountExporter.new(account).call
    end
  end

  def export_tags
    TagsExporter.new.call
  end

  def export_posts
    Post.find_each do |post|
      PostExporter.new(post).call
    end
  end

  def export_images
    ImagesExporter.new.call
  end
end
