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
    limit = limit.to_i
    Rails.cache.fetch(["recommended_posts", limit], expires_in: 7.days) do
      candidates = Post
        .from_normal_accounts
        .is_normal
        .is_opened
        .order(published_at: :desc)
        .limit(500)
        .pluck(:id)

      view_counts = if candidates.any?
                      ViewLog
                        .where(viewable_type: "Post", viewable_id: candidates)
                        .where(created_at: 1.month.ago..)
                        .group(:viewable_id)
                        .count
                    else
                      {}
                    end

      ranked_ids = candidates.sort_by { |id| -(view_counts[id] || 0) }

      Post
        .where(id: ranked_ids.first(limit))
        .order(Arel.sql("FIELD(id, #{ranked_ids.first(limit).join(',')})"))
    end
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
