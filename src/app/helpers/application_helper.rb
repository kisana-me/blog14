module ApplicationHelper
  def full_title(page_title = "")
    base_title = ENV.fetch("APP_NAME", nil)
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def full_url(path)
    File.join(ENV.fetch("APP_URL", nil), path)
  end

  def md_render(md, safe_render: false)
    ::MarkdownRenderer.render(md, safe_render: safe_render)
  end

  def md_render_toc(md)
    ::MarkdownRenderer.render_toc(md)
  end

  def md_render_plain(md)
    ::MarkdownRenderer.render_plain(md)
  end
end
