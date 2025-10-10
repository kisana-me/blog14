require "rouge/plugins/redcarpet"

class MarkdownRenderer
  class CustomHTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def preprocess(text)
      text.gsub(/\?\[post\]\(([a-zA-Z0-9\-_]+)\)/) do
        post = Post.from_normal_accounts.is_published.find_by(name_id: $1.split("/").last)
        if post
          ApplicationController.renderer.render(
            "posts/show_mini",
            locals: { post: post },
            layout: false
          ).delete("\n\r\t")
        else
          "[存在しない記事]"
        end
      end
    end
  end

  def self.render(markdown_text, safe_render: false)
    options = {
      hard_wrap: true,
      with_toc_data: true,
      filter_html: safe_render
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
    renderer = CustomHTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(markdown_text || "").html_safe
  end

  def self.render_toc(markdown_text)
    renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 6)
    markdown = Redcarpet::Markdown.new(renderer, space_after_headers: true)
    markdown.render(markdown_text || "").html_safe
  end

  def self.render_plain(markdown_text)
    html = render(markdown_text)
    # Rails.application.helpers.strip_tags(html)
    ApplicationController.helpers.strip_tags(html)
  end
end
