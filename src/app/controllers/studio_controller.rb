class StudioController < ApplicationController
  before_action :logged_in_account
  def index
    @draft_posts = @current_account.posts.where(
      draft: true,
      deleted: false
    )
    @deleted_posts = @current_account.posts.where(
      deleted: true
    )
  end
  private
end