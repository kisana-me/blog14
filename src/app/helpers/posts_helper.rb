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

  def recommended_posts(limit = 5)
    Post
      .from_normal_accounts
      .is_published
      .limit(limit.to_i)
      .order(views_count: :desc)
      .includes(:thumbnail)
  end

  def new_posts(limit = 5)
    Post
      .from_normal_accounts
      .is_published
      .limit(limit.to_i)
      .order(published_at: :desc)
      .includes(:thumbnail)
  end
end
