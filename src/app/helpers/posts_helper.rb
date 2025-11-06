module PostsHelper
  # Paging

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
      .is_normal
      .is_opened
      .order(edited_at: :desc)
      .limit(limit.to_i)
      .includes(:thumbnail)
  end

  def new_posts(limit = 5)
    Post
      .from_normal_accounts
      .is_normal
      .is_opened
      .order(published_at: :desc)
      .limit(limit.to_i)
      .includes(:thumbnail)
  end
end
