class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show ]

  def index
    @accounts = Account.order(id: :asc)
  end

  def show
    render_404 unless @account = Account.find_by(aid: params[:aid])
  end
end
