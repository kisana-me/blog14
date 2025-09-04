class StudioController < ApplicationController
  before_action :require_signin

  def index
    # 投稿をページングしたい
    @posts = @current_account.posts.isnt_deleted.limit(10).includes(:thumbnail)
  end
end
