module PostsHelper
  def markdown(text)
    options = {
      hard_wrap: true,
      with_toc_data: true
    }
    extensions = {
      tables: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
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
    renderer = CustomMarkdownRenderer.new(self, options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
  def toc(text)
      renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 6)
      markdown = Redcarpet::Markdown.new(renderer, space_after_headers: true)
      markdown.render(text).html_safe
  end
  # paging
  def posts_page
    total_posts = Post.where(
      public: true,
      deleted: false
    ).count
    per_page = 10 # 表示件数
    return total_posts > 0 ? (total_posts.to_f / per_page.to_f).ceil : 0
  end
  def paged_posts(param)
    param = param.to_i
    page = param < 1 ? 1 : param
    limit_item = 10 # 表示件数
    offset_item = (page - 1) * limit_item
    return Post.where(
      public: true,
      deleted: false
    ).offset(
      offset_item.to_i
    ).limit(
      limit_item.to_i
    ).order(
      id: :desc
    )
  end
  # posts
  def recommended_posts(limit)
    return Post.where(
      public: true,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      views_count: :desc
    )
  end
  def new_posts(limit)
    return Post.where(
      public: true,
      deleted: false
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
      public: true,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      edited_at: :desc
    )
  end
  def whos_posts(who, limit)
    return who.posts.where(
      public: true,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      published_at: :desc
    )
  end
  def tags_posts(tag, limit)
    return tag.posts.where(
      public: true,
      deleted: false
    ).limit(
      limit.to_i
    ).order(
      published_at: :desc
    )
  end
end
