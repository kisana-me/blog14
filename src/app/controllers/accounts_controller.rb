class AccountsController < ApplicationController
  before_action :require_signin, only: %i[ edit update destroy ]
  before_action :set_account, only: %i[ show ]
  before_action :set_correct_account, only: %i[ edit update destroy ]

  def index
    @accounts = Account.order(id: :asc)
  end

  def show
  end

  def edit#settingsへ移行しろ
  end

  def update
    if @account.update(account_params)
      flash[:notice] = '変更しました'
      redirect_to account_path(@account.aid)
    else
      flash.now[:alert] = '変更できませんでした'
      render 'edit'
    end
  end

  def destroy
  end

  private

  def account_params
    params.require(:account).permit(
      :icon,
      :name,
      :name_id,
      :description,
      :password,
      :password_confirmation,
      :public
    )
  end

  def set_account
    render_404 unless @account = Account.find_by(aid: params[:aid])
  end

  def set_correct_account
    render_404 unless @current_account
    @account = Account.find_by(aid: @current_account.aid)
  end
end
