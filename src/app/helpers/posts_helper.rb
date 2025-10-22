module PostsHelper
  # Paging

  def posts_page
    total_posts = Post.where(status: :published).count
    per_page = 20 # 表示件数
    total_posts.positive? ? (total_posts.to_f / per_page).ceil : 0
  end

  def paged_posts(param)
    param = param.to_i
    page = [param, 1].max
    limit_item = 20 # 表示件数
    offset_item = (page - 1) * limit_item
    Post.where(
      status: :published
    ).offset(
      offset_item.to_i
    ).limit(
      limit_item.to_i
    ).order(
      id: :desc
    )
  end

  # Posts

  def recommended_posts(limit)
    Post.where(
      status: :published
    ).limit(
      limit.to_i
    ).order(
      views_count: :desc
    )
  end

  def new_posts(limit)
    Post.where(
      status: :published
    ).limit(
      limit.to_i
    ).order(
      published_at: :desc
    )
  end

  def edited_posts(limit)
    Post.where.not(
      edited_at: nil
    ).where(
      status: :published
    ).limit(
      limit.to_i
    ).order(
      edited_at: :desc
    )
  end
end
