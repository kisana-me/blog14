class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update ]
  before_action :logged_in_account, only: %i[ logout edit update ]
  before_action :logged_out_account, only: %i[ signup create_signup login create_login ]
  def signup
    @account = Account.new
  end
  def create_signup
    account = Account.new(account_params)
    account.account_id = unique_random_id(Account, 'account_id')
    if account.save
      redirect_to account_path(account.name_id)
      flash[:success] = '作成しました'
    else
      @reform = {
        invitation_code: params[:account][:invitation_code],
        name: params[:account][:name],
        name_id: params[:account][:name_id],
        password: params[:account][:password],
        password_confirmation: params[:account][:password_confirmation]
      }
      flash.now[:danger] = '作成できませんでした'
      render 'signup'
    end
  end
  def login
  end
  def create_login
    account = Account.find_by(
      name_id: params[:session][:name_id].downcase,
      locked: false
    )
    if account && account.authenticate(params[:session][:password])
      log_in(account)
      flash[:success] = 'ログインしました'
      redirect_to root_url
    else
      @error_message = 'IDかパスワードが間違っています'
      @reform = {
        name_id: params[:session][:name_id],
        password: params[:session][:password]
      }
      flash.now[:danger] = 'ログインできませんでした'
      render 'login'
    end
  end
  def logout
    log_out
    flash[:success] = 'ログアウトしました'
    redirect_to root_url
  end
  def show
  end
  def edit
    # 未実装
  end
  def update
    # 未実装
    if @account.update(update_account_params)
      flash[:success] = '変更しました'
    else
      # @reform
      flash.now[:danger] = '変更できませんでした'
      render 'edit'
    end
  end

  private

  def account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :bio,
      :email,
      :password,
      :password_confirmation
    )
  end
  def update_account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :bio,
      :email
    )
  end
  def set_account
    @account = Account.find_by(
      name_id: params[:name_id],
      locked: false
    )
  end
end
