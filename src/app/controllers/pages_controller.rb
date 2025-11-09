class PagesController < ApplicationController
  def index
    @post = Post.unscoped.find_by(name_id: "index", status: :specific)
  end

  def terms_of_service
    @post = Post.unscoped.find_by(name_id: "terms_of_service", status: :specific)
  end

  def privacy_policy
    @post = Post.unscoped.find_by(name_id: "privacy_policy", status: :specific)
  end

  def contact
    @post = Post.unscoped.find_by(name_id: "contact", status: :specific)
  end

  def sitemap
    @post = Post.unscoped.find_by(name_id: "sitemap", status: :specific)
  end
end
