class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show ]

  def index
    @accounts = Account.where(visibility: :opened).order(id: :asc)
    # ページング
  end

  def show
    # 投稿をページング
  end

  private

  def set_account
    return if @account = Account.where(visibility: [:opened, :limited]).find_by(name_id: params[:name_id])
    return @account = Account.unscoped.find_by(name_id: params[:name_id]) if admin?
    render_404
  end
end
