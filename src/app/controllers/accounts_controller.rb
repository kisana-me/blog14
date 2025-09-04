class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show ]

  def index
    # アカウントをページングしたい
    @accounts = Account.is_normal.is_opened.limit(10).includes(:icon)
  end

  def show
    # 投稿をページングしたい
    # アクセスカウントしたい
    @posts = @account.posts.from_normal_accounts.is_published.order(published_at: :desc).limit(10).includes(:thumbnail)
  end

  private

  def set_account
    return if @account = Account.is_normal.isnt_closed.find_by(name_id: params[:name_id])
    return if admin? && @account = Account.find_by(name_id: params[:name_id])
    render_404
  end
end
