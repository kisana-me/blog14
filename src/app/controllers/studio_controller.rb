class StudioController < ApplicationController
  before_action :require_signin
  def index
    @unlisted_posts = @current_account.posts.where(status: :unlisted)
    @private_posts = @current_account.posts.where(status: :private)
  end
end
