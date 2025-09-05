module PostsHelper

  # Paging

  def posts_page
    total_posts = Post.where(status: :published).count
    per_page = 20 # 表示件数
    return total_posts > 0 ? (total_posts.to_f / per_page.to_f).ceil : 0
  end

  def paged_posts(param)
    param = param.to_i
    page = param < 1 ? 1 : param
    limit_item = 20 # 表示件数
    offset_item = (page - 1) * limit_item
    return Post.where(
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
    return Post.where(
      status: :published
    ).limit(
      limit.to_i
    ).order(
      views_count: :desc
    )
  end

  def new_posts(limit)
    return Post.where(
      status: :published
    ).limit(
      limit.to_i
    ).order(
      published_at: :desc
    )
  end

  def edited_posts(limit)
    return Post.where.not(
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
