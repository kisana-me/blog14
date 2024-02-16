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
  def find_draft_post(post_name_id)
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
end
