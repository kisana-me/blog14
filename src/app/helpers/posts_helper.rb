module PostsHelper
  def markdown(text)
    options = {
      hard_wrap: true,
      with_toc_data: true
    }
    extensions = {
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      space_after_headers: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true
    }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(options), extensions)
    markdown.render(text).html_safe
  end
  def toc(text)
      renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
      markdown = Redcarpet::Markdown.new(renderer, space_after_headers: true)
      markdown.render(text).html_safe
  end
  def all_posts
    Post.where(
      draft: false,
      deleted: false
    ).order(
      created_at: :desc
    )
  end
  def posts_page
    total_posts = Post.where(
      draft: false,
      deleted: false
    ).count
    per_page = 10 # 表示件数
    return total_posts > 0 ? (total_posts.to_i / per_page).ceil : 0
  end
  def paged_posts(param)
    param = param.to_i
    page = param < 1 ? 1 : param
    limit_item = 10 # 表示件数
    offset_item = (page - 1) * limit_item
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
      views_count: :desc
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
  def whos_posts(who, limit)
    return who.posts.where(
      draft: false,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      created_at: :desc
    )
  end
end
