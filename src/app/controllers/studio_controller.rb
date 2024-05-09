class StudioController < ApplicationController
  before_action :logged_in_account
  def index
    @unlisted_posts = @current_account.posts.where(
      unlisted: true,
      public: false,
      deleted: false
    )
    @private_posts = @current_account.posts.where(
      unlisted: false,
      public: false,
      deleted: false
    )
    @deleted_posts = @current_account.posts.where(
      deleted: true
    )
  end
end