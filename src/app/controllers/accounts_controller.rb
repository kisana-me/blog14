class AccountsController < ApplicationController
  include ViewLogger

  before_action :set_account, only: %i[show]

  def index
    # アカウントをページングしたい
    @accounts = Account
      .is_normal
      .is_opened
      .limit(10)
      .includes(:icon)
  end

  def show
    # 投稿をページングしたい

    @is_account_owner = @current_account && (@current_account.id == @account.id || admin?)
    unless @is_account_owner
      log_view(@account)
    end

    @posts = @account.posts
      .from_normal_accounts
      .is_normal
      .is_opened
      .limit(10)
      .order(published_at: :desc)
      .includes(:thumbnail)
  end

  private

  def set_account
    return if (@account = Account.is_normal.isnt_closed.find_by(name_id: params[:name_id]))
    return if admin? && (@account = Account.unscoped.find_by(name_id: params[:name_id]))

    render_404
  end
end
