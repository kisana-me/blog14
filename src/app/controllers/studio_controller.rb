class StudioController < ApplicationController
  before_action :logged_in_account
  def index
    @unlisted_posts = @current_account.posts.where(status: :unlisted)
    @private_posts = @current_account.posts.where(status: :private)
  end
end