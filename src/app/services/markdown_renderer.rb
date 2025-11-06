require "rouge/plugins/redcarpet"

class MarkdownRenderer
  class CustomHTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def preprocess(text)
      # support embedding a mini post preview using ?[post](name_id)
      text = text.gsub(/\?\[post\]\(([a-zA-Z0-9\-_]+)\)/) do
        post = Post.from_normal_accounts.is_published.find_by(name_id: ::Regexp.last_match(1).split("/").last)
        if post
          ApplicationController.renderer.render(
            "posts/_show_mini",
            locals: { post: post },
            layout: false
          ).delete("\n\r\t")
        else
          "[存在しない記事]"
        end
      end

      # support embedding an image (single or multiple) using ?[image](aid|caption, aid2|caption2)
      # - each item: aid or aid|caption
      # - multiple items: separated by comma
      # produces <figure> with an <a><img></a> and <figcaption>, or a wrapper div.markdown-image-slider
      text = text.gsub(/\?\[image\]\(([^)]+)\)/) do
        raw = ::Regexp.last_match(1).to_s
        # split on comma to allow multiple images; captions use '|' to separate
        items = raw.split(',').map(&:strip).reject(&:empty?)

        figures = items.map do |item|
          aid, caption = item.split('|', 2).map { |s| s.to_s.strip }
          image = Image.from_normal_accounts.is_normal.find_by(aid: aid)
          if image
            href = Rails.application.routes.url_helpers.image_path(image.aid)
            img_tag = ApplicationController.helpers.image_tag(image.image_url(variant_type: "normal"), alt: image.name)
            # build figcaption only when caption present
            figcap = caption.present? ? ApplicationController.helpers.content_tag(:figcaption, caption) : ""

            # figure contains anchor wrapping image, and optional figcaption
            ApplicationController.helpers.content_tag(:figure, img_tag + figcap, class: "markdown-image-figure").delete("\n\r\t")
          else
            ApplicationController.helpers.content_tag(:figure, "[存在しない画像]", class: "markdown-image-figure")
          end
        end

        if figures.size > 1
          # wrap multiple figures in a slider container; front-end can style .markdown-image-slider for horizontal sliding
          ApplicationController.helpers.content_tag(:div, figures.join.html_safe, class: "markdown-image-slider").delete("\n\r\t")
        else
          figures.first.to_s
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
