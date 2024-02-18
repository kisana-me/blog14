module PostsHelper
  def markdown(text)
    options = {
      tables: true,
    }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end
  def toc(text)
      renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
      markdown = Redcarpet::Markdown.new(renderer)
      markdown.render(text).html_safe
  end
  def find_post(post_name_id)
    Post.find_by(
      post_name_id: post_name_id,
      draft: false,
      deleted: false
    )
  end
  def find_correct_post(post_name_id)
    Post.find_by(
      post_name_id: post_name_id,
      deleted: false
    )
  end
  def all_posts
    Post.where(
      draft: false,
      deleted: false
    ).order(
      id: :desc
    )
  end
  def paged_posts(param)
    param = param.to_i
    page = param < 1 ? 1 : param
    offset_item = (page - 1) * 10 # 開始位置
    limit_item = 10 # 表示件数
    return Post.where(
      draft: false,
      deleted: false
    ).offset(
      offset_item.to_i
    ).limit(
      limit_item.to_i
    ).order(
      created_at: :desc
    )
  end
  def recommended_posts(limit)
    return Post.where(
      draft: false,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      created_at: :desc
    )
  end
  def new_posts(limit)
    return Post.where(
      draft: false,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      created_at: :desc
    )
  end
end
