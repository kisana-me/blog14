class CustomMarkdownRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Rails.application.routes.url_helpers

  def initialize(view_context, options = {})
    super(options)
    @view = view_context
  end

  def preprocess(text)
    text.gsub(/\?\[post\]\(([a-z0-9]+)\)/) do
      post = Post.find_by(aid: $1.split("/").last)
      if post
        @view.render("posts/show_mini", post: post).delete("\n\r\t")
      else
        "[存在しない記事]"
      end
    end
  end
end
